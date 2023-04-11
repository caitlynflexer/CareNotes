//
//  ManageUsersTableViewCont.swift
//  CareNotes
//
//  Created by Caitlyn Flexer on 2/22/23.
//

import UIKit

class ManageUsersTableViewCont: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // top bar
        self.navigationItem.title = "Manage Users"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Back", style: .plain, target: self, action:#selector(ManageUsersTableViewCont.back(_:)))
        
        self.navigationItem.scaleText();
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        goBack()
    }
    
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataMgr.instance().getUsers().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        userCell.textLabel?.text = DataMgr.instance().getUsers()[indexPath.row].getUserName() + " (" + DataMgr.instance().getUsers()[indexPath.row].getRole() + ")"
        userCell.textLabel?.textAlignment = .center
        if (UIDevice.isPad) {
            userCell.textLabel?.font = UIFont.init(name: "Helvetica", size: 25)
        }
        return userCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userSelected = DataMgr.instance().getUsers()[indexPath.row]
        DataMgr.instance().setInspectUserId(userID: userSelected.getID())
        let newViewCont = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailsTableViewControllerID") as! UserDetailsTableViewController
        self.navigationController?.pushViewController(newViewCont, animated: true)
    }
}
