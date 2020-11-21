//
//  TodoListTableView.swift
//  RxTodo
//
//  Created by 方昱恒 on 2020/11/21.
//

import UIKit

extension TodoListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        
        let titleLabel = cell.viewWithTag(1002) as? UILabel
        titleLabel?.text = todoItems.value[indexPath.row].name
        
        let finishedLabel = cell.viewWithTag(1001) as? UILabel
        finishedLabel?.text = todoItems.value[indexPath.row].isFinished ? "✔️" : ""
        
        return cell
    }
    
}

extension TodoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        var newItems = todoItems.value
        newItems.remove(at: indexPath.row)
        todoItems.accept(newItems)
    }
    
}
