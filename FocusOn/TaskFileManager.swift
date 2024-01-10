
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

            if (self.newCreate) {
                let taskFileHdr = "Created    " + "  Completed  " + " Deleted    " + " Task\n"
                if let taskFileHdrData = taskFileHdr.data(using: .utf8) {
                    self.fileHandle?.write(taskFileHdrData)
                } else {
                    print("Error converting task file header to data.")
                }
            }
        } catch {
            print("Error opening file for updating: \(error)")
        }
    }

    func writeToFile(message: String) {
        guard let fileHandle = fileHandle, let data = "\(message)\n".data(using: .utf8) else {
            return
        }

        fileHandle.seekToEndOfFile()
        fileHandle.write(data)
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
