//
//  TodoListViewControllerConfig.swift
//  RxTodo
//
//  Created by 方昱恒 on 2020/11/21.
//

import UIKit

extension TodoListViewController {
    
    func documentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return path[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("TodoList.plist")
    }
    
    func saveTodoItems() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        
        archiver.encode(todoItems.value, forKey: "TodoItems")
        archiver.finishEncoding()
        
        data.write(to: dataFilePath(), atomically: true)
    }
    
    func loadTodoItems() {
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            todoItems.accept(unarchiver.decodeObject(forKey: "TodoItems") as! [TodoItem])
            
            unarchiver.finishDecoding()
        }
    }
    
}
