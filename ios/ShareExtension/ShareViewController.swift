import UIKit
import UniformTypeIdentifiers

final class ShareViewController: UIViewController {
    private var started = false
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !started else { return }; started = true
        view.backgroundColor = .systemBackground
        let label = UILabel(frame: view.bounds.insetBy(dx: 24, dy: 40))
        label.text = "正在安全暂存到鱼者文游…"; label.numberOfLines = 0
        view.addSubview(label)
        Task { @MainActor in
            do {
                try await receive()
                label.text = "已暂存，请打开鱼者文游继续预览。"
                let button = UIButton(type: .system)
                button.setTitle("完成", for: .normal)
                button.frame = CGRect(x: 24, y: 80, width: 200, height: 50)
                button.addTarget(self, action: #selector(finish), for: .touchUpInside)
                view.addSubview(button)
            } catch {
                label.text = "无法读取分享内容或内容超过限制，请重新分享较小文件。"
                let button = UIButton(type: .system)
                button.setTitle("关闭", for: .normal); button.frame = CGRect(x:24,y:80,width:200,height:50)
                button.addTarget(self, action: #selector(fail), for: .touchUpInside); view.addSubview(button)
            }
        }
    }
    @objc private func finish() { extensionContext?.completeRequest(returningItems: nil, completionHandler: nil) }
    @objc private func fail() {
        extensionContext?.cancelRequest(withError: NSError(
            domain: "com.yuzhe.fishtextadventure.share-intake", code: 1,
            userInfo: [NSLocalizedDescriptionKey: "鱼者文游未能暂存分享内容。"]
        ))
    }
    private func receive() async throws {
        let items = extensionContext?.inputItems as? [NSExtensionItem] ?? []
        let providers = items.flatMap { $0.attachments ?? [] }
        guard !providers.isEmpty, providers.count <= 16 else { throw IntakeError.invalid }
        let id = UUID().uuidString.lowercased()
        let root = try ShareInbox.root()
        let dir = root.appendingPathComponent(id, isDirectory: true)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        var files = [[String: Any]](); var texts = [String](); var total: Int64 = 0
        do {
            for provider in providers {
                if provider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                    let value = try await loadItem(provider, type: UTType.url.identifier)
                    if let url = value as? URL, ["https", "http"].contains(url.scheme?.lowercased() ?? "") {
                        texts.append(url.absoluteString); continue
                    }
                }
                if provider.hasItemConformingToTypeIdentifier(UTType.plainText.identifier) &&
                    !provider.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) {
                    let value = try await loadItem(provider, type: UTType.plainText.identifier)
                    if let text = value as? String { texts.append(text); continue }
                }
                let type = provider.registeredTypeIdentifiers.first(where: {
                    guard let t = UTType($0) else { return false }
                    return t.conforms(to: .image) || t.conforms(to: .data) || t.conforms(to: .content)
                })
                guard let type else { throw IntakeError.invalid }
                let record = try await copyFile(provider, type: type, directory: dir, total: total)
                total += record["size"] as? Int64 ?? 0
                files.append(record)
            }
            let text = texts.joined(separator: "\n")
            guard text.utf8.count <= 512 * 1024 else { throw IntakeError.invalid }
            let manifest: [String: Any] = ["id": id, "source":"system", "mime":"text/plain",
                "receivedAt": Int64(Date().timeIntervalSince1970 * 1000), "text":text, "files":files]
            try ShareInbox.write(manifest, directory: dir)
        } catch {
            // Only the fresh per-event directory is eligible for cleanup.
            try? FileManager.default.removeItem(at: dir)
            throw IntakeError.invalid
        }
    }
    private func loadItem(_ provider: NSItemProvider, type: String) async throws -> NSSecureCoding {
        try await withCheckedThrowingContinuation { continuation in
            provider.loadItem(forTypeIdentifier: type, options:nil) { value, error in
                if let value { continuation.resume(returning: value) }
                else { continuation.resume(throwing: error ?? IntakeError.invalid) }
            }
        }
    }
    private func copyFile(_ provider: NSItemProvider, type: String, directory: URL, total: Int64) async throws -> [String:Any] {
        try await withCheckedThrowingContinuation { continuation in
            // The provider URL is only valid inside this callback; copy here.
            provider.loadFileRepresentation(forTypeIdentifier: type) { url, error in
                do {
                    guard let url else { throw error ?? IntakeError.invalid }
                    let started = url.startAccessingSecurityScopedResource()
                    defer { if started { url.stopAccessingSecurityScopedResource() } }
                    let target = directory.appendingPathComponent(UUID().uuidString + ".bin")
                    let count = try ShareInbox.copyBounded(from:url, to:target, already:total)
                    let mime = UTType(type)?.preferredMIMEType ?? "application/octet-stream"
                    let name = provider.suggestedName ?? url.lastPathComponent
                    let backupType = "com.yuzhe.fishtextadventure.story"
                    let backup = type == backupType || url.pathExtension.lowercased() == "yuzhe"
                    let shown = backup ? String((name as NSString).deletingPathExtension.prefix(154)) + ".yuzhe" : String(name.prefix(160))
                    continuation.resume(returning: ["path": target.path, "name": shown, "mime": mime, "size": count])
                } catch { continuation.resume(throwing:IntakeError.invalid) }
            }
        }
    }
}