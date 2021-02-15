//
//  ModelToDoList.swift
//  ToDoListMVC
//
//  Created by ИГОРЬ on 10/02/2021.
//

import Foundation


var sortedAscending: Bool = true

struct Task {
    var caption: String
    var completed: Bool
}

class Model {
    
    //список задач
    var toDoTasks: [Task] = [
        Task(caption: "Купить еды для кота", completed: false),
        Task(caption: "Впусить кота в дом", completed: false),
        Task(caption: "Покормить кота", completed: false),
        Task(caption: "Напоить кота", completed: false),
        Task(caption: "Поиграть с котом", completed: false),
        Task(caption: "Выпусить кота из дома", completed: false),
        Task(caption: "Погулять с котом", completed: false),
        Task(caption: "Узнать, не хочет ли кот еще что-нибудь", completed: false)
        ]
    
    
    // добавление новой задачи в список задач
    func addTask(itemCaption: String, isCompleted: Bool = false) {
        let newItem = Task(caption: itemCaption, completed: isCompleted)
        toDoTasks.append(newItem)
        
    }
    
    //удаление задачи из списка задач
    func removeTask(at index: Int) {
        toDoTasks.remove(at: index)
    }
    
    //изменение задачи в списке задач
    func updateTask(at index: Int, with caption: String){
        toDoTasks[index].caption = caption
    }
    
    // выполнено --> невыполнено --> выполнено
    func changeTaskState(at task: Int) -> Bool {
        toDoTasks[task].completed = !toDoTasks[task].completed
        return toDoTasks[task].completed
    }
}

