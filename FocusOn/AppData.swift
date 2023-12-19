import Foundation

struct AppData: Codable {
    var totalCountdownSeconds: Int
    var selectedTime: Int
    var selectedTarget: Int
    var currState: Int
    var countdownSeconds: Int
    var todoItems: [TodoItem]
    var showFocusOn: Bool
    var showTodoList: Bool
    var totalCountdownEnd: Date
}

class AppDataStore {
    static let shared = AppDataStore()
    private let key = "FocusOnAppDataKey"
    private init() {}

    func saveData(_ appData: AppData, to fileURL: URL) {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(appData)
            try encodedData.write(to: fileURL)
        } catch {
            print("Error saving data: \(error)")
        }
    }

    func loadData(from fileURL: URL) -> AppData? {
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let appData = try decoder.decode(AppData.self, from: data)
            return appData
        } catch {
            print("Error loading data: \(error)")
            return nil
        }
    }
}
