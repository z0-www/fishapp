import Foundation

enum IntakeError: Error { case invalid }
enum ShareInbox {
    static let group = "group.com.yuzhe.fishtextadventure"

    /// Staging root shared by the app and its share extension.
    ///
    /// A real App Group is used when the provisioning profile grants one. With
    /// a free personal team (e.g. Sideloadly) the App Group is stripped, so the
    /// app falls back to its own Application Support directory: importing from
    /// the Files picker keeps working, while the system share extension cannot
    /// hand off files and reports a clear failure instead.
    static func root() throws -> URL {
        if let base = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: group
        ) {
            return try prepare(base.appendingPathComponent("share_inbox", isDirectory: true))
        }
        guard Bundle.main.bundleURL.pathExtension != "appex" else {
            throw IntakeError.invalid
        }
        guard let support = FileManager.default.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first else {
            throw IntakeError.invalid
        }
        return try prepare(support.appendingPathComponent("share_inbox", isDirectory: true))
    }

    private static func prepare(_ dir: URL) throws -> URL {
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        var values = URLResourceValues()
        values.isExcludedFromBackup = true
        // File protection is best effort; a missing passcode must not block import.
        try? dir.setResourceValues(values)
        return dir.resolvingSymlinksInPath()
    }
    static func write(_ data: [String:Any], directory: URL) throws {
        let bytes = try JSONSerialization.data(withJSONObject:data)
        let url = directory.appendingPathComponent("ready.json")
        do {
            try bytes.write(to: url, options: [.atomic, .completeFileProtection])
        } catch {
            // A device without a passcode cannot apply complete protection.
            // The staged copy is still app-sandboxed; fall back to atomic write
            // instead of failing the whole import.
            try bytes.write(to: url, options: .atomic)
        }
    }
    static func pending() throws -> [[String:Any]] {
        var items = [[String:Any]]()
        for dir in try FileManager.default.contentsOfDirectory(at:root(),includingPropertiesForKeys:nil) {
            guard let bytes = try? Data(contentsOf:dir.appendingPathComponent("ready.json")),
                  let value = try? JSONSerialization.jsonObject(with:bytes) as? [String:Any],
                  value["delivered"] as? Bool != true else { continue }
            items.append(value)
            if items.count == 8 { break }
        }
        return items
    }
    static func ack(_ id: String) throws {
        guard UUID(uuidString:id) != nil else { throw IntakeError.invalid }
        let dir = try root().appendingPathComponent(id, isDirectory:true)
        let url = dir.appendingPathComponent("ready.json")
        guard FileManager.default.fileExists(atPath:url.path) else { return }
        guard var data = try JSONSerialization.jsonObject(with: Data(contentsOf: url)) as? [String: Any] else {
            throw IntakeError.invalid
        }
        data["delivered"] = true
        try write(data, directory:dir)
    }
    static func copyBounded(from: URL, to: URL, already: Int64) throws -> Int64 {
        let expected = (try from.resourceValues(forKeys:[.fileSizeKey])).fileSize ?? 0
        guard expected <= 64 * 1024 * 1024 else { throw IntakeError.invalid }
        let root = try self.root()
        var queueSize: Int64 = 0
        if let enumerator = FileManager.default.enumerator(at:root, includingPropertiesForKeys:[.fileSizeKey,.isRegularFileKey]) {
            for case let file as URL in enumerator {
                let values = try file.resourceValues(forKeys:[.fileSizeKey,.isRegularFileKey])
                if values.isRegularFile == true { queueSize += Int64(values.fileSize ?? 0) }
            }
        }
        guard let input = InputStream(url:from), let output = OutputStream(url:to,append:false) else { throw IntakeError.invalid }
        input.open(); output.open(); defer { input.close(); output.close() }
        var buffer = [UInt8](repeating:0,count:64*1024); var count:Int64 = 0
        while true {
            let read = input.read(&buffer,maxLength:buffer.count)
            if read == 0 { break }; guard read > 0 else { throw IntakeError.invalid }
            count += Int64(read)
            guard count <= 64*1024*1024, count+already <= 128*1024*1024, queueSize+count <= 256*1024*1024 else { throw IntakeError.invalid }
            try buffer.withUnsafeBufferPointer { pointer in
                var offset=0
                while offset < read {
                    let written=output.write(pointer.baseAddress!.advanced(by:offset),maxLength:read-offset)
                    guard written > 0 else { throw IntakeError.invalid }; offset += written
                }
            }
        }
        // Best effort: an unprotected device cannot apply complete protection.
        try? FileManager.default.setAttributes([.protectionKey:FileProtectionType.complete],ofItemAtPath:to.path)
        return count
    }
}