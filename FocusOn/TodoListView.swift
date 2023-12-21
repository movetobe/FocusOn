import SwiftUI

struct TodoItem: Identifiable,Codable {
    var id = UUID()
    var task: String
    var isCompleted: Bool = false
    var isEditing: Bool = false
}

struct TodoListView: View {
    @Binding var todoItems: [TodoItem]
    @State private var newTask: String = ""
    
    var body: some View {
        VStack {
            ForEach(todoItems.indices, id: \.self) { index in
                let todoItem = todoItems[index]
                HStack {
                    Button(action: {
                        toggleTaskCompletion(todoItem: todoItem)
                    }) {
                        Image(systemName: todoItem.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(Utils.color)
                    }
                    .buttonStyle(.borderless)
                    
                    if (!todoItem.isEditing) {
                        if (!todoItem.isCompleted) {
                            Text(todoItem.task)
                                .onTapGesture (count: 2) {
                                    editTask(index: index)
                                }
                        } else {
                            Text(todoItem.task)
                                .strikethrough(todoItem.isCompleted, color: Color.gray)
                                .foregroundColor(Color.gray)
                                .onTapGesture (count: 2) {
                                    editTask(index: index)
                                }
                        }
                    } else {
                        TextField("Edit Task", text: Binding(
                            get: { return todoItems[index].task },
                            set: { newText in todoItems[index].task = newText }
                        ), onCommit: {
                            // Perform saveTask action
                            saveTask(index: index)
                        })
                        .textFieldStyle(PlainTextFieldStyle())
                        .background(Utils.colorBase)
                    }
                    Spacer()
                    Button(action: {
                        deleteTask(index: index)
                    }) {
                        Image(systemName: "minus.circle")
                            .foregroundColor(Utils.color)
                    }
                    .buttonStyle(.borderless)
                }
            }
            TextField("Add a new task", text: $newTask, onCommit: addTask)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(Utils.paddingSize)
    }

    func toggleTaskCompletion(todoItem: TodoItem) {
        if let index = todoItems.firstIndex(where: { $0.id == todoItem.id }) {
            todoItems[index].isCompleted.toggle()
        }
    }
    
    func editTask(index: Int) {
        todoItems[index].isEditing = true
    }
    
    func saveTask(index: Int) {
        todoItems[index].isEditing = false
    }

    func addTask() {
        guard !newTask.isEmpty else { return }
        let todoItem = TodoItem(task: newTask)
        todoItems.append(todoItem)
        newTask = ""
    }

    func deleteTask(index: Int) {
        todoItems.remove(at: index)
    }
}
