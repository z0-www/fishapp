import Foundation

enum IntakeError: Error { case invalid }
enum ShareInbox {
    static let group = "group.com.yuzhe.fishtextadventure"
    static func root() throws -> URL {
        guard let base = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier:group) else { throw IntakeError.invalid }
        var dir = base.appendingPathComponent("share_inbox", isDirectory:true)
        try FileManager.default.createDirectory(at:dir, withIntermediateDirectories:true)
        var values = URLResourceValues(); values.isExcludedFromBackup = true
        try dir.setResourceValues(values)
        return dir.resolvingSymlinksInPath()
    }
    static func write(_ data: [String:Any], directory: URL) throws {
        let bytes = try JSONSerialization.data(withJSONObject:data)
        try bytes.write(to:directory.appendingPathComponent("ready.json"), options:[.atomic, .completeFileProtection])
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
        try FileManager.default.setAttributes([.protectionKey:FileProtectionType.complete],ofItemAtPath:to.path)
        return count
    }
}