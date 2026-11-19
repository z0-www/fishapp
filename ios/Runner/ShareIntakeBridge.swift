import Flutter
import UIKit
import UniformTypeIdentifiers

final class ShareIntakeBridge: NSObject, UIDocumentPickerDelegate {
    private let channel: FlutterMethodChannel
    private let worker = DispatchQueue(label: "com.yuzhe.fishtextadventure.share-intake", qos: .userInitiated)
    private var pickerResult: FlutterResult?
    private var exporting = false
    private static var backupType: UTType { UTType(exportedAs: "com.yuzhe.fishtextadventure.story") }

    init(messenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(name: "fish/share_intake", binaryMessenger: messenger)
        super.init()
        channel.setMethodCallHandler { [weak self] call, result in
            guard let self else {
                result(FlutterError(code: "bridge", message: "文件功能暂不可用", details: nil))
                return
            }
            switch call.method {
            case "pending":
                worker.async {
                    do {
                        let items = try ShareInbox.pending()
                        DispatchQueue.main.async { result(items) }
                    } catch {
                        DispatchQueue.main.async {
                            result(FlutterError(code: "inbox", message: "共享暂存区不可用，请检查 App Groups 配置", details: nil))
                        }
                    }
                }
            case "ack":
                let id = (call.arguments as? [String: Any])?["id"] as? String ?? ""
                worker.async {
                    do {
                        try ShareInbox.ack(id)
                        DispatchQueue.main.async { result(nil) }
                    } catch {
                        DispatchQueue.main.async {
                            result(FlutterError(code: "ack", message: "暂存交接失败，请重试", details: nil))
                        }
                    }
                }
            case "pickFiles":
                let picker = UIDocumentPickerViewController(
                    forOpeningContentTypes: [.plainText, .json, .zip, .image, .html, Self.backupType, .data],
                    asCopy: false
                )
                picker.allowsMultipleSelection = true
                present(picker, exporting: false, result: result)
            case "saveStoryBackup":
                guard let path = (call.arguments as? [String: Any])?["path"] as? String,
                      let url = Self.exportFile(path) else {
                    result(FlutterError(code: "export", message: "备份暂存文件不可用", details: nil))
                    return
                }
                present(UIDocumentPickerViewController(forExporting: [url], asCopy: true), exporting: true, result: result)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    private static func exportFile(_ path: String) -> URL? {
        let manager = FileManager.default
        guard let cache = manager.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        let root = cache.appendingPathComponent("yuzhe_export").resolvingSymlinksInPath()
        let file = URL(fileURLWithPath: path).resolvingSymlinksInPath()
        guard file.deletingLastPathComponent().deletingLastPathComponent().path == root.path,
              file.pathExtension == "yuzhe",
              let values = try? file.resourceValues(forKeys: [.isRegularFileKey, .fileSizeKey]),
              values.isRegularFile == true, let size = values.fileSize,
              size > 0, size <= 64 * 1024 * 1024 else { return nil }
        return file
    }

    private func present(_ picker: UIDocumentPickerViewController, exporting: Bool, result: @escaping FlutterResult) {
        guard pickerResult == nil else {
            result(FlutterError(code: "busy", message: "文件选择器已打开", details: nil))
            return
        }
        guard let scene = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }),
              var controller = scene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            result(FlutterError(code: "window", message: "请在鱼者文游前台打开文件", details: nil))
            return
        }
        while let presented = controller.presentedViewController { controller = presented }
        self.exporting = exporting
        pickerResult = result
        picker.delegate = self
        controller.present(picker, animated: true)
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        pickerResult?(false)
        pickerResult = nil
        exporting = false
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let reply = pickerResult
        pickerResult = nil
        if exporting {
            exporting = false
            if urls.isEmpty {
                reply?(FlutterError(code: "export", message: "未收到备份写入回执", details: nil))
            } else {
                reply?(true)
            }
            return
        }
        worker.async {
            var staging: URL?
            do {
                guard !urls.isEmpty, urls.count <= 16 else { throw IntakeError.invalid }
                let id = UUID().uuidString.lowercased()
                let dir = try ShareInbox.root().appendingPathComponent(id, isDirectory: true)
                try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: false)
                staging = dir
                var files = [[String: Any]]()
                var total: Int64 = 0
                for url in urls {
                    let access = url.startAccessingSecurityScopedResource()
                    defer { if access { url.stopAccessingSecurityScopedResource() } }
                    let target = dir.appendingPathComponent(UUID().uuidString + ".bin")
                    let count = try ShareInbox.copyBounded(from: url, to: target, already: total)
                    total += count
                    let type = UTType(filenameExtension: url.pathExtension)?.preferredMIMEType ?? "application/octet-stream"
                    files.append(["path": target.path, "name": String(url.lastPathComponent.prefix(160)), "mime": type, "size": count])
                }
                try ShareInbox.write([
                    "id": id, "source": "picker", "mime": "application/octet-stream",
                    "receivedAt": Int64(Date().timeIntervalSince1970 * 1000), "files": files,
                ], directory: dir)
                DispatchQueue.main.async {
                    self.channel.invokeMethod("changed", arguments: nil)
                    reply?(true)
                }
            } catch {
                if let staging { try? FileManager.default.removeItem(at: staging) }
                DispatchQueue.main.async {
                    reply?(FlutterError(code: "picker", message: "文件读取失败或超过限制", details: nil))
                }
            }
        }
    }
}
