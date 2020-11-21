//
//  ViewController.swift
//  RxTodo
//
//  Created by 方昱恒 on 2020/11/20.
//

import UIKit
import RxSwift
import RxCocoa

class TodoListViewController: UIViewController {

// MARK: - Properties
    var todoItems = BehaviorRelay<[TodoItem]>(value: [TodoItem]())
    var disposedBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clearTodoButton: UIButton!
    @IBOutlet weak var addTodoButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTodoItems()
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)
        
        todoItems.asObservable().subscribe(onNext: { [weak self] todos in
            self?.updateUI(todos: todos)
            self?.saveTodoItems()
        })
        .disposed(by: disposedBag)
    }
    
    private func updateUI(todos: [TodoItem]) {
        clearTodoButton.isEnabled = !todoItems.value.isEmpty
        addTodoButton.isEnabled = todos.filter { !$0.isFinished }.count < 5
        self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
}

// MARK: - Segues

extension TodoListViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navigationController = segue.destination as! UINavigationController
        let detailVC = navigationController.topViewController as! TodoDetailViewController
        
        if segue.identifier == "AddTodo" {
            detailVC.title = "Add Todo"
            _ = detailVC.todoObservable.subscribe(onNext: { [weak self] item in
                var newItems = self?.todoItems.value
                newItems?.append(item)
                self?.todoItems.accept(newItems!)
            })

        } else if segue.identifier == "EditTodo" {
            detailVC.title = "Edit Todo"
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                var newItems = self.todoItems.value
                detailVC.todoItem = self.todoItems.value[indexPath.row]

                _ = detailVC.todoObservable.subscribe(onNext: { [weak self] item in
                    newItems[indexPath.row] = item
                    self?.todoItems.accept(newItems)
                })
            }
        }
        
    }
    
}


// MARK: - Button
extension TodoListViewController {
    
    @IBAction func addButtonTapped(_ sender: Any) {
        var todos = todoItems.value
        todos.append(TodoItem(name: "A new todo.", isFinished: false))
        todoItems.accept(todos)
    }
    
    @IBAction func clearTodos(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
}
