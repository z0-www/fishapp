package com.yuzhe.fishtextadventure

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.provider.OpenableColumns
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject
import java.io.File
import java.io.FileOutputStream
import java.security.MessageDigest
import java.util.UUID
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {
    private val worker = Executors.newSingleThreadExecutor()
    private var channel: MethodChannel? = null
    private var picker: MethodChannel.Result? = null
    private var backupExport: Pair<File, MethodChannel.Result>? = null
    private val inbox get() = File(filesDir, "share_inbox").apply { mkdirs() }
    // Build configuration limits; no broad storage permission is needed.
    private val maxFile = 64L * 1024 * 1024
    private val maxEvent = 128L * 1024 * 1024
    private val maxQueue = 256L * 1024 * 1024
    private val maxText = 512 * 1024

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "fish/share_intake")
        channel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "pending" -> worker.execute {
                    val items = inbox.listFiles().orEmpty().asSequence().mapNotNull { dir ->
                        try {
                            val file = File(dir, "ready.json")
                            if (!file.exists()) null else JSONObject(file.readText()).let {
                                if (it.optBoolean("delivered")) null else toMap(it)
                            }
                        } catch (_: Exception) { null }
                    }.sortedBy { (it["receivedAt"] as? Number)?.toLong() ?: 0L }.take(8).toList()
                    runOnUiThread { result.success(items) }
                }
                "ack" -> {
                    val id = call.argument<String>("id") ?: ""
                    val keepFiles = call.argument<Boolean>("keepFiles") ?: true
                    if (!id.matches(Regex("[a-fA-F0-9-]{36}"))) result.error("invalid", "暂存编号无效", null)
                    else worker.execute {
                        try {
                            val dir = File(inbox, id)
                            val ready = File(dir, "ready.json")
                            if (ready.exists()) {
                                val data = JSONObject(ready.readText())
                                if (!keepFiles || data.optJSONArray("files")?.length() == 0) {
                                    // Flutter committed the payload first. This directory belongs to
                                    // this event; only retained attachments need its files.
                                    for (file in dir.listFiles().orEmpty()) check(file.delete())
                                    check(dir.delete())
                                } else {
                                    atomicJson(dir, data.put("delivered", true))
                                }
                            }
                            runOnUiThread { result.success(null) }
                        } catch (_: Exception) { runOnUiThread { result.error("ack", "暂存交接失败，可稍后重试", null) } }
                    }
                }
                "pickFiles" -> {
                    if (picker != null || backupExport != null) result.error("busy", "文件选择器已打开", null)
                    else {
                        picker = result
                        try {
                            startActivityForResult(Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
                                type = "*/*"; addCategory(Intent.CATEGORY_OPENABLE)
                                putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true)
                                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                            }, 5107)
                        } catch (_: Exception) { picker = null; result.error("picker", "无法打开系统文件选择器", null) }
                    }
                }
                "saveStoryBackup" -> {
                    if (picker != null || backupExport != null) {
                        result.error("busy", "文件选择器已打开", null)
                    } else try {
                        val file = File(call.argument<String>("path") ?: "").canonicalFile
                        val root = File(cacheDir, "yuzhe_export").canonicalFile
                        if (file.parentFile?.parentFile != root || !file.isFile ||
                            file.extension != "yuzhe" || file.length() > maxFile) {
                            result.error("export", "备份暂存文件不可用", null)
                        } else {
                            backupExport = file to result
                            startActivityForResult(Intent(Intent.ACTION_CREATE_DOCUMENT).apply {
                                type = "application/vnd.yuzhe.story"
                                addCategory(Intent.CATEGORY_OPENABLE)
                                putExtra(Intent.EXTRA_TITLE, file.name)
                            }, 5108)
                        }
                    } catch (_: Exception) {
                        backupExport = null
                        result.error("export", "无法打开系统保存界面", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        accept(intent, "system")
    }
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        accept(intent, "system")
    }
    @Deprecated("Android legacy result bridge retained for FlutterActivity")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == 5108) {
            val (source, reply) = backupExport ?: return
            backupExport = null
            val target = data?.data
            if (resultCode != Activity.RESULT_OK || target == null) {
                reply.success(false)
            } else worker.execute {
                try {
                    val output = contentResolver.openOutputStream(target, "wt")
                        ?: throw java.io.IOException("No output")
                    output.use { out -> source.inputStream().use { it.copyTo(out) } }
                    runOnUiThread { reply.success(true) }
                } catch (_: Exception) {
                    runOnUiThread { reply.error("export", "备份写入未完成", null) }
                }
            }
            return
        }
        if (requestCode != 5107) return
        val reply = picker; picker = null
        if (resultCode == Activity.RESULT_OK && data != null) {
            stage(data, "picker") { reply?.success(true) }
        } else reply?.success(false)
    }
    private fun accept(intent: Intent?, source: String) {
        if (intent?.action == Intent.ACTION_SEND || intent?.action == Intent.ACTION_SEND_MULTIPLE) stage(intent, source)
    }
    @Suppress("DEPRECATION")
    private fun stage(intent: Intent, source: String, complete: (() -> Unit)? = null) {
        // Snapshot while the temporary URI grants and original Intent are alive.
        val mime = intent.type ?: "application/octet-stream"
        val extraText = runCatching {
            if (mime == "text/html") intent.getStringExtra(Intent.EXTRA_HTML_TEXT)
                ?: intent.getCharSequenceExtra(Intent.EXTRA_TEXT)?.toString()
            else intent.getCharSequenceExtra(Intent.EXTRA_TEXT)?.toString()
        }.getOrNull()?.takeIf { it.isNotBlank() }
        val uris = mutableListOf<Uri>()
        val clipText = mutableListOf<String>()
        var publicLink: String? = null
        fun addUri(uri: Uri) {
            if (uri.scheme == "https" || uri.scheme == "http") {
                publicLink = publicLink ?: uri.toString()
            } else {
                uris.add(uri)
            }
        }
        runCatching {
            if (intent.action == Intent.ACTION_SEND_MULTIPLE) {
                intent.getParcelableArrayListExtra<Uri>(Intent.EXTRA_STREAM)?.forEach(::addUri)
            } else {
                intent.getParcelableExtra<Uri>(Intent.EXTRA_STREAM)?.let(::addUri)
            }
        }
        intent.clipData?.let { clip ->
            for (i in 0 until minOf(clip.itemCount, 17)) {
                val item = clip.getItemAt(i)
                item.text?.toString()?.takeIf { it.isNotBlank() }?.let(clipText::add)
                item.uri?.let(::addUri)
            }
        }
        intent.data?.let(::addUri)
        val text = extraText ?: clipText.takeIf { it.isNotEmpty() }?.joinToString("\n") ?: publicLink
        worker.execute {
            val id = UUID.randomUUID().toString()
            val dir = File(inbox, id).apply { mkdirs() }
            val payload = JSONObject().put("id", id).put("source", source)
                .put("receivedAt", System.currentTimeMillis()).put("mime", mime)
            try {
                val distinct = uris.distinct()
                require(distinct.size <= 16)
                require((text?.toByteArray(Charsets.UTF_8)?.size ?: 0) <= maxText)
                val usage = inbox.walkTopDown().filter { it.isFile }.sumOf { it.length() }
                require(usage <= maxQueue)
                if (text != null) payload.put("text", text)
                val files = JSONArray()
                var total = 0L
                for (uri in distinct) {
                    require(uri.scheme == "content")
                    var name = "分享文件"
                    contentResolver.query(uri, arrayOf(OpenableColumns.DISPLAY_NAME, OpenableColumns.SIZE), null, null, null)?.use { cursor ->
                        if (cursor.moveToFirst()) {
                            val n = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME)
                            if (n >= 0) name = cursor.getString(n)?.take(160) ?: name
                            val s = cursor.getColumnIndex(OpenableColumns.SIZE)
                            if (s >= 0 && !cursor.isNull(s)) require(cursor.getLong(s) <= maxFile)
                        }
                    }
                    val target = File(dir, UUID.randomUUID().toString() + ".bin")
                    val digest = MessageDigest.getInstance("SHA-256")
                    var count = 0L
                    contentResolver.openInputStream(uri)?.use { input ->
                        FileOutputStream(target).use { output ->
                            val buffer = ByteArray(64 * 1024)
                            while (true) {
                                val size = input.read(buffer); if (size < 0) break
                                count += size; total += size
                                require(count <= maxFile && total <= maxEvent && usage + total <= maxQueue)
                                output.write(buffer, 0, size); digest.update(buffer, 0, size)
                            }
                            output.fd.sync()
                        }
                    } ?: throw IllegalStateException("unreadable")
                    files.put(JSONObject().put("path", target.canonicalPath).put("name", name)
                        .put("mime", contentResolver.getType(uri) ?: mime).put("size", count)
                        .put("sha256", digest.digest().joinToString("") { "%02x".format(it) }))
                }
                require(text != null || files.length() > 0)
                payload.put("files", files)
                val contentDigest = MessageDigest.getInstance("SHA-256")
                contentDigest.update((mime + "\n" + (text ?: "")).toByteArray(Charsets.UTF_8))
                for (i in 0 until files.length()) contentDigest.update(files.getJSONObject(i).getString("sha256").toByteArray())
                val fingerprint = contentDigest.digest().joinToString("") { "%02x".format(it) }
                val duplicate = inbox.listFiles().orEmpty().any { other ->
                    if (other == dir) false else try {
                        val waiting = JSONObject(File(other, "ready.json").readText())
                        !waiting.optBoolean("delivered") && waiting.optString("fingerprint") == fingerprint
                    } catch (_: Exception) { false }
                }
                if (duplicate) {
                    dir.listFiles().orEmpty().forEach { it.delete() }; dir.delete()
                    runOnUiThread { channel?.invokeMethod("changed", null); complete?.invoke() }
                    return@execute
                }
                payload.put("fingerprint", fingerprint)
                atomicJson(dir, payload)
            } catch (_: Exception) {
                // Only this newly allocated private directory may be cleaned.
                dir.listFiles().orEmpty().filter { it.name != "ready.json" }.forEach { it.delete() }
                payload.remove("text")
                payload.put("files", JSONArray()).put("error", "分享内容无法读取、权限已失效或超过暂存限制，请重新分享较小文件。")
                try { atomicJson(dir, payload) } catch (_: Exception) { /* no content is logged */ }
            }
            runOnUiThread { channel?.invokeMethod("changed", null); complete?.invoke() }
        }
    }
    private fun atomicJson(dir: File, value: JSONObject) {
        val temporary = File(dir, "ready.tmp")
        FileOutputStream(temporary).use { output -> output.write(value.toString().toByteArray(Charsets.UTF_8)); output.fd.sync() }
        check(temporary.renameTo(File(dir, "ready.json")))
    }
    private fun toMap(value: JSONObject): Map<String, Any?> = value.keys().asSequence().associateWith { key ->
        when (val item = value.get(key)) {
            JSONObject.NULL -> null
            is JSONObject -> toMap(item)
            is JSONArray -> (0 until item.length()).map { i -> (item.get(i) as? JSONObject)?.let { toMap(it) } ?: item.get(i) }
            else -> item
        }
    }
}