//
//  SelectUserViewCont.swift
//  CareNotes
//
//  Created by Caitlyn Flexer on 2/17/23.
//

import UIKit

class SelectUserViewCont: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectMember: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

extension SelectUserViewCont: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row < DataMgr.instance().getNumUsers()) {
            let currUserId = DataMgr.instance().getUsers()[indexPath.row].getID()
            DataMgr.instance().setCurrentUserId(userId: currUserId)
            let newViewCont = self.storyboard?.instantiateViewController(withIdentifier: "JournalTableViewControllerID") as! JournalTableViewController
            self.navigationController?.pushViewController(newViewCont, animated: true)
        } else {
            // clicked add new user
            let newViewCont = self.storyboard?.instantiateViewController(withIdentifier: "CreateNewUserViewControllerID") as! CreateNewUserViewController
            self.navigationController?.pushViewController(newViewCont, animated: true)
        }
    }
}

extension SelectUserViewCont: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataMgr.instance().getNumUsers() + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        
        if indexPath.row == DataMgr.instance().getNumUsers() {
            userCell.textLabel?.text = "Add New User"
            userCell.textLabel?.textColor = .tintColor
        } else {
            let user = DataMgr.instance().getUsers()[indexPath.row]
            userCell.textLabel?.textColor = .black
            if (user.isCaregiver()) {
                userCell.textLabel?.text = user.getUserName()
            } else {
                userCell.textLabel?.text = user.getUserName() + " (" + user.getRole() + ")"
            }
        }
        
        if (UIDevice.isPad) {
            userCell.textLabel?.font = UIFont.init(name: "Helvetica", size: 28)
        }
        userCell.textLabel?.textAlignment = .center
        return userCell
    }
}



