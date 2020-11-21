//
//  AddTodoController.swift
//  RxTodo
//
//  Created by 方昱恒 on 2020/11/21.
//

import UIKit
import RxSwift
import RxCocoa

class TodoDetailViewController: UITableViewController {
    
    var todoItem = TodoItem()
    private var disposeBag = DisposeBag()
    
    private var todoSubject = PublishSubject<TodoItem>()
    var todoObservable: Observable<TodoItem> {
        return todoSubject.asObservable()
    }
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var editTextField: UITextField!
    @IBOutlet weak var finishedSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        editTextField.text = todoItem.name
        finishedSwitch.isOn = todoItem.isFinished
        doneButton.isEnabled = editTextField.text?.count != 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        todoSubject.onCompleted()
    }
    
    @IBAction func done(_ sender: Any) {
        todoItem.name = editTextField.text ?? ""
        todoItem.isFinished = finishedSwitch.isOn
        
        todoSubject.onNext(todoItem)
        todoSubject.onCompleted()
        
        dismiss(animated: true, completion: nil)
    }
    
}


extension TodoDetailViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text! as NSString
        let new = text.replacingCharacters(in: range, with: string)
        
        doneButton.isEnabled = (new.count != 0)
        
        return true
    }
    
}
