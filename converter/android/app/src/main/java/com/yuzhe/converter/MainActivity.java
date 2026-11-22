package com.yuzhe.converter;

import android.app.Activity;
import android.content.ContentResolver;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Color;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.OpenableColumns;
import android.util.Base64;
import android.view.View;
import android.view.Window;
import android.webkit.JavascriptInterface;
import android.webkit.ValueCallback;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;

import org.json.JSONObject;

import java.io.OutputStream;

/**
 * Lightweight, fully offline WebView shell for the FishTextAdventure converter.
 *
 * No INTERNET permission is declared. The UI is loaded from app assets; the
 * only external interaction is the Android system document picker / create
 * document UI. The original FishTextAdventure package is never modified.
 */
public class MainActivity extends Activity {
    private static final int PICK_FILE = 1001;
    private static final int SAVE_FILE = 1002;
    private static final long MAX_INPUT_BYTES = 64L * 1024 * 1024;
    private static final int MAX_SAVE_BYTES = 32 * 1024 * 1024;

    private WebView webView;
    private ValueCallback<Uri[]> filePathCallback;
    private byte[] pendingSaveBytes;
    private String pendingSaveName;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        configureWindow();

        WebView.setWebContentsDebuggingEnabled(false);
        webView = new WebView(this);
        webView.setBackgroundColor(Color.WHITE);
        setContentView(webView);

        WebSettings settings = webView.getSettings();
        settings.setJavaScriptEnabled(true);
        settings.setDomStorageEnabled(true);
        settings.setDatabaseEnabled(true);
        settings.setAllowFileAccess(true);
        settings.setAllowContentAccess(true);
        settings.setAllowFileAccessFromFileURLs(false);
        settings.setAllowUniversalAccessFromFileURLs(false);
        settings.setJavaScriptCanOpenWindowsAutomatically(false);
        settings.setSupportMultipleWindows(false);
        settings.setMediaPlaybackRequiresUserGesture(true);
        try {
            settings.setBlockNetworkLoads(true);
        } catch (Exception ignored) {
            // No INTERNET permission is declared; this is defence in depth.
        }

        webView.addJavascriptInterface(new Bridge(), "FishAndroid");
        webView.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
                return !isLocalAsset(request.getUrl());
            }

            @Override
            @SuppressWarnings("deprecation")
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                return !url.startsWith("file:///android_asset/");
            }
        });
        webView.setWebChromeClient(new WebChromeClient() {
            @Override
            public boolean onShowFileChooser(
                    WebView view,
                    ValueCallback<Uri[]> callback,
                    FileChooserParams params) {
                if (filePathCallback != null) {
                    filePathCallback.onReceiveValue(null);
                }
                filePathCallback = callback;
                Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT);
                intent.addCategory(Intent.CATEGORY_OPENABLE);
                intent.setType("*/*");
                intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                try {
                    startActivityForResult(intent, PICK_FILE);
                } catch (Exception error) {
                    filePathCallback = null;
                    callback.onReceiveValue(null);
                    toast("无法打开系统文件选择器");
                }
                return true;
            }
        });

        webView.loadUrl("file:///android_asset/converter/index.html");
    }

    private void configureWindow() {
        Window window = getWindow();
        window.setStatusBarColor(Color.rgb(246, 248, 252));
        window.setNavigationBarColor(Color.WHITE);
        View decor = window.getDecorView();
        int flags = decor.getSystemUiVisibility();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            flags |= View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR;
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            flags |= View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR;
        }
        decor.setSystemUiVisibility(flags);
    }

    private boolean isLocalAsset(Uri uri) {
        return uri != null && "file".equals(uri.getScheme())
                && uri.getPath() != null
                && uri.getPath().startsWith("/android_asset/converter/");
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == PICK_FILE) {
            ValueCallback<Uri[]> callback = filePathCallback;
            filePathCallback = null;
            if (callback == null) return;
            Uri uri = (resultCode == RESULT_OK && data != null) ? data.getData() : null;
            if (uri == null) {
                callback.onReceiveValue(null);
                return;
            }
            try {
                getContentResolver().takePersistableUriPermission(
                        uri, Intent.FLAG_GRANT_READ_URI_PERMISSION);
            } catch (Exception ignored) {
                // The temporary grant from ACTION_OPEN_DOCUMENT is sufficient.
            }
            long size = querySize(uri);
            if (size > MAX_INPUT_BYTES) {
                callback.onReceiveValue(null);
                toast("文件超过 64 MiB，转换器不会打开");
                return;
            }
            callback.onReceiveValue(new Uri[]{uri});
            return;
        }
        if (requestCode == SAVE_FILE) {
            byte[] bytes = pendingSaveBytes;
            String name = pendingSaveName;
            pendingSaveBytes = null;
            pendingSaveName = null;
            if (resultCode != RESULT_OK || data == null || data.getData() == null) {
                updateResultUi(false, "已取消保存；归档仍在内存中，可以再次点保存。");
                return;
            }
            if (bytes == null) {
                updateResultUi(false, "没有待保存的数据，请重新生成归档。");
                return;
            }
            Uri uri = data.getData();
            try (OutputStream output = getContentResolver().openOutputStream(uri, "wt")) {
                if (output == null) throw new IllegalStateException("no output stream");
                output.write(bytes);
                output.flush();
                toast("已保存");
                updateResultUi(true, "已保存到系统选择的位置。现在打开鱼者文游 → 完整故事备份 → 从 .yuzhe 备份恢复。不要使用「DeepSeek 对话导入」。");
            } catch (Exception error) {
                toast("保存失败，请重试");
                updateResultUi(false, "保存失败；归档仍在内存中，可以再次点保存。");
            }
        }
    }

    private long querySize(Uri uri) {
        try (Cursor cursor = getContentResolver().query(
                uri, new String[]{OpenableColumns.SIZE}, null, null, null)) {
            if (cursor != null && cursor.moveToFirst()) {
                int index = cursor.getColumnIndex(OpenableColumns.SIZE);
                if (index >= 0 && !cursor.isNull(index)) return cursor.getLong(index);
            }
        } catch (Exception ignored) {
            // Fall through; the web converter has its own 64 MiB check.
        }
        return 0;
    }

    private void toast(String message) {
        runOnUiThread(() -> Toast.makeText(this, message, Toast.LENGTH_LONG).show());
    }

    private void updateResultUi(boolean saved, String message) {
        if (webView == null) return;
        String title = saved ? "已保存" : "已生成";
        String css = saved ? "status" : "status bad";
        String js = "(function(){var t=document.getElementById('resultTitle');"
                + "var s=document.getElementById('exportStatus');"
                + "var m=document.getElementById('resultMeta');"
                + "if(t)t.textContent=" + JSONObject.quote(title) + ";"
                + "if(m&&" + (saved ? "true" : "false")
                + ")m.textContent=m.textContent.replace(' · 尚未保存',' · 已保存');"
                + "if(s){s.hidden=false;s.className=" + JSONObject.quote(css)
                + ";s.textContent=" + JSONObject.quote(message) + ";}})();";
        webView.evaluateJavascript(js, null);
    }

    private final class Bridge {
        @JavascriptInterface
        public boolean saveFile(String name, String mime, String base64) {
            if (base64 == null || base64.isEmpty()) {
                toast("归档为空，未保存");
                return false;
            }
            // Base64 is ~4/3 of the binary size; cap before decoding to avoid OOM.
            if ((long) base64.length() > (MAX_SAVE_BYTES * 4L / 3L) + 16) {
                toast("归档超过 32 MiB，Android 包装器拒绝保存");
                return false;
            }
            final byte[] bytes;
            try {
                bytes = Base64.decode(base64, Base64.DEFAULT);
            } catch (IllegalArgumentException error) {
                toast("归档数据损坏，未保存");
                return false;
            }
            if (bytes.length == 0 || bytes.length > MAX_SAVE_BYTES) {
                toast("归档大小无效，未保存");
                return false;
            }
            final String safeName = sanitizeName(name);
            final String safeMime = (mime == null || mime.isEmpty())
                    ? "application/octet-stream" : mime;
            pendingSaveBytes = bytes;
            pendingSaveName = safeName;
            runOnUiThread(() -> {
                try {
                    Intent intent = new Intent(Intent.ACTION_CREATE_DOCUMENT);
                    intent.addCategory(Intent.CATEGORY_OPENABLE);
                    intent.setType(safeMime);
                    intent.putExtra(Intent.EXTRA_TITLE, safeName);
                    intent.addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
                    startActivityForResult(intent, SAVE_FILE);
                } catch (Exception error) {
                    pendingSaveBytes = null;
                    pendingSaveName = null;
                    toast("无法打开系统保存界面");
                    updateResultUi(false, "无法打开系统保存界面，请重试。");
                }
            });
            return true;
        }

        @JavascriptInterface
        public boolean openYuzhe() {
            Intent intent = getPackageManager()
                    .getLaunchIntentForPackage("com.yuzhe.fishtextadventure");
            if (intent == null) return false;
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            try {
                startActivity(intent);
                return true;
            } catch (Exception error) {
                return false;
            }
        }
    }

    private String sanitizeName(String name) {
        String value = (name == null ? "" : name)
                .replaceAll("[\\\\/:*?\"<>|\\r\\n\\t]", "_")
                .trim();
        if (value.isEmpty()) value = "鱼者文游-对话导入.yuzhe";
        if (value.length() > 160) value = value.substring(0, 160);
        return value;
    }

    @Override
    @SuppressWarnings("deprecation")
    public void onBackPressed() {
        if (webView != null && webView.canGoBack()) {
            webView.goBack();
        } else {
            super.onBackPressed();
        }
    }

    @Override
    protected void onDestroy() {
        if (webView != null) {
            webView.removeJavascriptInterface("FishAndroid");
            webView.destroy();
            webView = null;
        }
        super.onDestroy();
    }
}
