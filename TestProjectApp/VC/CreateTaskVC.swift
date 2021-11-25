//
//  CreateTaskVC.swift
//  TestProjectApp
//
//  Created by Igor Abovyan on 14.11.2021.
//

import UIKit

class CreateTaskVC: UIViewController {
    
    var textField: UITextField!
    var task: Task!
}

//MARK: Life cycle
extension CreateTaskVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.config()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.textField.becomeFirstResponder()
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        textField.endEditing(true)
        CoreDataManager.shered.saveContext()
    }
}

//MARK: Config
extension CreateTaskVC {
    private func config() {
        self.createTextField()
    }
    
    private func createTextField() {
        textField = UITextField.init()
        textField.frame.size.width = self.view.frame.size.width
        textField.frame.size.height = 50
        textField.frame.origin.x = CGFloat.offset
        textField.frame.origin.y = self.view.frame.size.height * 0.13
        textField.placeholder = "I want to..."
        textField.font = UIFont.systemFont(ofSize: 20)
        self.view.addSubview(textField)
        
        textField.delegate = self
        task.name = textField.text
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        navigationController?.popViewController(animated: false)
    }
}

//MARK: TextField Delegate
extension CreateTaskVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        task.name = textField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}



