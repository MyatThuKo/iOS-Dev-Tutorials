//
//  ContentView.swift
//  To Do List
//
//  Created by Myat Thu Ko on 1/23/21.
//

import SwiftUI

struct TaskListView: View {
    @ObservedObject var taskListVM = TaskListViewModel()
    
    let tasks = testDataTasks
    
    @State var presentAddNewItem = false
    @State var showSignInForm = false
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading) {
                List {
                    ForEach(taskListVM.taskCellViewModel) { taskCellVM in
                        TaskCell(taskCellVM: taskCellVM)
                    }
                    if presentAddNewItem {
                        TaskCell(taskCellVM: TaskCellViewModel(task: Task(title: "", completed: false))) { task in
                            self.taskListVM.addTask(task: task)
                            presentAddNewItem.toggle()
                        }
                    }
                }
                Button(action: {
                    presentAddNewItem.toggle()
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                        Text("Add New Task")
                    }
                }.padding()
            }
            .navigationTitle("Tasks")
            .sheet(isPresented: $showSignInForm, content: {
                SignInView()
            })
            .navigationBarItems(trailing:
                                    Button(action: {
                                        self.showSignInForm.toggle()
                                    }, label: {
                                        Image(systemName: "person.circle")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                    })
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}

struct TaskCell: View {
    @ObservedObject var taskCellVM: TaskCellViewModel
    
    var onCommit: (Task) -> (Void) = { _ in
        
    }
    
    var body: some View {
        HStack {
            Image(systemName: taskCellVM.task.completed ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 25, height: 25)
                .onTapGesture {
                    self.taskCellVM.task.completed.toggle()
                }
            TextField("Enter the task title", text: $taskCellVM.task.title, onCommit: {
                self.onCommit(self.taskCellVM.task)
            })
        }
    }
}
