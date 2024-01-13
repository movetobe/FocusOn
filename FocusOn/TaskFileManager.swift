
import Foundation

class TaskFileManager {
    static let shared = TaskFileManager()
    var fileHandle: FileHandle?
    private var newCreate = false

    private init() {
        guard let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(Utils.taskFile) else {
            return
        }

        if !(FileManager.default.fileExists(atPath: fileURL.path)) {
            FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
            self.newCreate = true
        }

        do {
            self.fileHandle = try FileHandle(forUpdating: fileURL)
        } catch {
            print("Error opening file for updating: \(error)")
        }
    }

    func writeToFile(message: String) {
        DispatchQueue.main.async { [self] in
            guard let fileHandle = self.fileHandle else {
                return
            }
            /* read original data */
            let originalData = self.readFromFile()
            let data = message + (originalData ?? "")
            fileHandle.seek(toFileOffset: 0)
            fileHandle.write(data.data(using: .utf8)!)
        }
    }

    func readFromFile() -> String? {
        guard let fileHandle = fileHandle else {
            return ""
        }
        var tasks: String = ""
        fileHandle.seek(toFileOffset: 0)
        let data = fileHandle.readDataToEndOfFile()
        if let content = String(data: data, encoding: .utf8) {
            tasks = content
        } else {
            print("Error decoding file content.")
        }
        return tasks
    }
}
