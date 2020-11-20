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
        
        todoItems.asObservable().subscribe(onNext: { [weak self] todos in
            self?.updateUI(todos: todos)
        }).disposed(by: disposedBag)
    }
    
    private func updateUI(todos: [TodoItem]) {
        clearTodoButton.isEnabled = !todoItems.value.isEmpty
        addTodoButton.isEnabled = todos.filter { !$0.isFinished }.count < 5
        self.tableView.reloadData()
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
        todoItems.accept([TodoItem]())
    }
    
}

// MARK: - UITableViewDataSource
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

// MARK: - UITableViewDelegate
extension TodoListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todos = todoItems.value
        todos[indexPath.row].isFinished = !todos[indexPath.row].isFinished
        todoItems.accept(todos)
    }
    
}
