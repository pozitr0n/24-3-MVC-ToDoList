//
//  Model.swift
//  MyToDoList_With_MVC
//
//  Created by Raman Kozar on 10/12/2022.
//

import Foundation
import UIKit

// MARK: The Model-file contains all the functionality for calculating and processing various actions

// MARK: Class declaration describing the content of the cell
//
class CellItem {
    
    // MARK: Cell content
    var content: String
    
    // MARK: Status (whether the task is completed or not)
    var taskCompleted: Bool
    
    // MARK: The standard class initializer
    init(content: String, taskCompleted: Bool) {
        self.content = content
        self.taskCompleted = taskCompleted
    }
    
}

// MARK: Declaration of the class of the model in which we will carry out all calculations
//
class TableModel {
    
    // MARK: Clicking on the edit button
    var editBtnClicked: Bool = false
    
    // MARK: Creating an array of tasks that will appear when the application is opened (just for test)
    var arrayTasks: [CellItem] = [CellItem(content: "Test task no. 1", taskCompleted: false),
                                  CellItem(content: "Test task no. 2", taskCompleted: true)]
    
    // MARK: Adding sorting tasks in ascending order (by task name)
    var sortAsc: Bool = true
    
    // MARK: Adding new task into the list
    func addTask(taskName: String,
                 completed: Bool = false) {
        
        arrayTasks.append(CellItem(content: taskName, taskCompleted: completed))
        
    }
    
    // MARK: Deleting the task (by index)
    func removeTask(at index: Int) {
        arrayTasks.remove(at: index)
    }
    
    // MARK: Updating the task (by index)
    func updateTask(at index: Int,
                    with content: String) {
        
        arrayTasks[index].content = content
        
    }
    
    // MARK: Changing the status of a task to completed or not completed
    func changeTaskStatus(at index: Int) -> Bool {
        
        // MARK: Previous state
        let prevCondition = arrayTasks[index].taskCompleted
        
        arrayTasks[index].taskCompleted = !prevCondition
        return arrayTasks[index].taskCompleted
        
    }
    
    // MARK: Adding sorting of the tasks
    func sortAscDesc() {
        
        // MARK: Adding a closure for a sort condition
        arrayTasks.sort {
            sortAsc ? $0.content < $1.content : $0.content > $1.content
        }
        
    }
    
}
