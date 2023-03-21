//
//  CreateNewUserViewController.swift
//  CareNotes
//
//  Created by Caitlyn Flexer on 2/19/23.
//

import UIKit

class CreateNewUserViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Create New User"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action:#selector(NewVitalsTableViewController.back(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Save", style: .done, target: self, action:#selector(NewVitalsTableViewController.saveBtnClicked(_:)))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        userNameTextField.addTarget(self, action: #selector(CreateNewUserViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userNameTextField.becomeFirstResponder()
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        goBack()
    }
    
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        save()
    }
    
    func save() {
        let newUserName = userNameTextField.text?.trim()
        
        let users = DataMgr.instance().getUsers()
        var userNameExists = false
        
        for curUser in users {
            if (curUser.getUserName() == newUserName) {
                showDialog()
                userNameExists = true
            }
        }
        
        if (userNameExists == false) {
            if (!newUserName!.isEmpty) {
                let newUser = User(_name: newUserName!, _role: UserRole.caregiver)
                DataMgr.instance().addUser(user: newUser)
            }
            goBack()
        }
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if (!textField.text!.trim().isEmpty) {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    func showDialog() {
        let alert = UIAlertController(title: nil, message: "User name already exists. Please choose a different name.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


