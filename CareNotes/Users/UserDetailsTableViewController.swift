//
//  UserDetailsTableViewController.swift
//  CareNotes
//
//  Created by Caitlyn Flexer on 2/23/23.
//

import UIKit

class UserDetailsTableViewController: UITableViewController {
    
    var userId : Int = 0
    var user : User = DataMgr.instance().getCurrentUser()!
    
    var editMode = false
    var nameChanged = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userId = DataMgr.instance().getInspectUserId()
        user = DataMgr.instance().getUserById(id: userId)!
        
        self.navigationItem.title = "User Details"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Back", style: .plain, target: self, action:#selector(UserDetailsTableViewController.back(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Edit", style: .done, target: self, action:#selector(UserDetailsTableViewController.editBtnClicked(_:)))
        self.navigationItem.leftBarButtonItem?.isEnabled = true
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        goBack()
    }
    
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editBtnClicked(_ sender: UIBarButtonItem) {
        
        var userNameChanged = false
        
        if (editMode && nameChanged) {
            let users = DataMgr.instance().getUsers()
            
            for curUser in users {
                if (curUser.getUserName() == user.getUserName() && curUser.getID() != userId) {
                    showDialog()
                    userNameChanged = true
                }
            }
        }
        
        if (userNameChanged == false) {
            editMode = !editMode
            self.navigationItem.rightBarButtonItem!.title = editMode ? "Done" : "Edit"
            self.navigationItem.leftBarButtonItem?.isEnabled = editMode ? false : true
            tableView.reloadData()
        }
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @objc public func textFieldDidChange(_ textField: UITextField) {
        nameChanged = true
        
        let value : String = textField.text?.trim() ?? ""
        let property : String = textField.accessibilityIdentifier!
        
        if (property == "Name") {
            user.setUserName(newName : value)
            if (user.getRole() == "Care Recipient") {
                DataMgr.instance().setPatientName(name: value)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (user.getRole() != "Admin" && user.getRole() != "Care Recipient") ? 3 : 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if (indexPath.row == 0) {
            cell.textLabel?.textColor = .black
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.text = editMode ? "Name:" : "Name: " + user.getUserName()
        } else if (indexPath.row == 1) {
            cell.textLabel?.text = "Role: " + user.getRole()
        } else {
            if (user.getRole() != "Admin" && user.getRole() != "Care Recipient") {
                cell.textLabel?.textColor = .red
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.text = "Delete User"
            }
        }
        
        if (UIDevice.isPad) {
            cell.textLabel?.font = UIFont.init(name: "Helvetica", size: 25)
        }
        
        if (indexPath.row >= 1 || editMode == false) {
            cell.contentView.subviews[0].isHidden = true
        } else {
            cell.contentView.subviews[0].isHidden = false
            let textField:UITextField = cell.contentView.subviews[0] as! UITextField
            textField.accessibilityIdentifier = (indexPath.row == 0) ? "Name" : "Role"
            textField.text = (indexPath.row == 0) ? user.getUserName() : user.getRole()
            textField.addTarget(self, action: #selector(UserDetailsTableViewController.textFieldDidChange(_:)), for: .editingChanged)
            textField.keyboardType = UIKeyboardType.numbersAndPunctuation
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row < 2) {
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            showDeleteDialog()
        }
    }
    
    func showDeleteDialog() {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to delete this user?", preferredStyle: .alert)

        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            DataMgr.instance().removeUser(index: DataMgr.instance().getIndexOfUser(user: self.user))
            self.goBack()
        }
        
        alert.addAction(yesAction)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }
    
    func showDialog() {
        let alert = UIAlertController(title: nil, message: "User name already exists. Please choose a different name.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
