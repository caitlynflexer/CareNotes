//
//  ViewController.swift
//  CareNotes
//
//  Created by Caitlyn Flexer on 2/15/23.
//

import UIKit

class SetupViewCont: UIViewController, UITextFieldDelegate {
    /// Delete these 3 labels
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var recipientNameLabel: UILabel!

    @IBOutlet weak var adminNameLabel: UILabel!
    
    @IBOutlet weak var recipientNameField: UITextField!
    @IBOutlet weak var adminNameField: UITextField!
    @IBOutlet weak var setUp2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (DataMgr.instance().getUsers().count > 0) {
            // already set up user accounts; go directly to select user page
            let newViewCont = self.storyboard?.instantiateViewController(withIdentifier: "SelectUserViewContID") as! SelectUserViewCont
            self.navigationController?.pushViewController(newViewCont, animated: false)
            return
        }
        
        recipientNameLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        adminNameLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        setUp2.isUserInteractionEnabled = true
        let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(setUpBtnClicked(_:)))
        setUp2.addGestureRecognizer(guestureRecognizer)
        
    }

    @IBAction func setUpBtnClicked(_ sender: Any) {
        let adminName: String = adminNameField.text!.trim()
        let careRecipientName: String = recipientNameField.text!.trim()
        
        if (adminName == "" || careRecipientName == "") {
            showDialog()
        } else {
            let adminUser = User(_name: adminName, _role: UserRole.admin)
            DataMgr.instance().addUser(user: adminUser)
            
            let careRecipient = User(_name: careRecipientName, _role: UserRole.careRecipient)
            DataMgr.instance().addUser(user: careRecipient)
            DataMgr.instance().setPatientName(name: careRecipientName)
            
            DataMgr.instance().setCurrentUserId(userId: adminUser.getID())
                            
            let newViewCont = self.storyboard?.instantiateViewController(withIdentifier: "JournalTableViewControllerID") as! JournalTableViewController
            self.navigationController?.pushViewController(newViewCont, animated: true)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showDialog() {
        let alert = UIAlertController(title: nil, message: "Please enter both a care recipient and admin name.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}



