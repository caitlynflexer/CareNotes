//
//  JournalTableViewController.swift
//  CareNotes
//
//  Created by Caitlyn Flexer on 2/18/23.
//

import UIKit

class JournalTableViewController: UITableViewController {
    
    let centralCellReuseIdentifier = "centralCellReuseIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()

        // top bar
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Log out", style: .plain, target: self, action: #selector(self.logOut(_:)))
        
        let newEntry = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(self.newEntryBtnClicked(_:)))
        
        let newVitals = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(self.newVitalsBtnClicked(_:)))

        self.navigationItem.rightBarButtonItems = [newEntry, newVitals]
        
        
        // bottom bar
        if (DataMgr.instance().getCurrentUser()!.getRole() == "Admin") {
            self.navigationController?.isToolbarHidden = false
            let spaceItemLeft = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
            let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.circle.fill"), style: .plain, target: self, action: #selector(self.userBtnClicked(_:)))
            let spaceItemRight = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
            self.toolbarItems = [spaceItemLeft, barButtonItem, spaceItemRight]
        } else {
            self.navigationController?.isToolbarHidden = true
        }
        
        // table view 
        tableView.register(UINib(nibName: String(describing: CentralTableViewCell.self), bundle: nil), forCellReuseIdentifier: centralCellReuseIdentifier)
        tableView.rowHeight  = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.register(JournalHeaderView.self, forHeaderFooterViewReuseIdentifier: JournalHeaderView.identifier)
    }

    @IBAction func logOut(_ sender: UIBarButtonItem) {
        let newViewCont = self.storyboard?.instantiateViewController(withIdentifier: "SelectUserViewContID") as! SelectUserViewCont
        self.navigationController?.pushViewController(newViewCont, animated: false)
    }
    
    @objc func newEntryBtnClicked(_ sender: UIBarButtonItem) {
        let newViewCont = self.storyboard?.instantiateViewController(withIdentifier: "NewEntryViewContID") as! NewEntryViewCont
        self.navigationController?.pushViewController(newViewCont, animated: true)
    }
    
    @objc func newVitalsBtnClicked(_ sender: UIBarButtonItem) {
        let newViewCont = self.storyboard?.instantiateViewController(withIdentifier: "NewVitalsTableViewControllerID") as! NewVitalsTableViewController
        self.navigationController?.pushViewController(newViewCont, animated: true)
    }
    
    @objc func userBtnClicked(_ sender: UIBarButtonItem) {
        let newViewCont = self.storyboard?.instantiateViewController(withIdentifier: "ManageUsersTableViewContID") as! ManageUsersTableViewCont
        self.navigationController?.pushViewController(newViewCont, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        // set journal title here, as care recipient name may have been edited
        self.navigationItem.title = "Journal for " + DataMgr.instance().getPatientName()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return DataMgr.instance().getNumJournalEntries() == 0 ? 1 : DataMgr.instance().getNumSections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataMgr.instance().getNumJournalEntries() == 0 ? 1 : DataMgr.instance().numRowsInSection(sectionIndex: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: centralCellReuseIdentifier, for: indexPath) as! CentralTableViewCell
        
        if (DataMgr.instance().getNumJournalEntries() == 0) {
            cell.userLabel?.text = ""
            cell.journalEntry?.textColor = UIColor.gray
            cell.journalEntry?.textAlignment = .center
            cell.journalEntry?.text = "Tap icons above to create entries"
            cell.time?.text = ""
        } else {
            let journalEntry = DataMgr.instance().getJournalEntry(section: indexPath.section, row: indexPath.row)
            cell.userLabel?.text = journalEntry.getUser()
            cell.journalEntry?.textAlignment = .left
            cell.journalEntry?.textColor = UIColor.black
            cell.journalEntry?.text = journalEntry.getDisplayText()
            cell.time?.text = journalEntry.getTimeStr()
        }
        
        if (UIDevice.isPad) {
            cell.userLabel?.font = UIFont.init(name: "Helvetica", size: 20)
            cell.journalEntry?.font = UIFont.init(name: "Helvetica", size: 22)
            cell.time?.font = UIFont.init(name: "Helvetica", size: 20)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: JournalHeaderView.identifier) as? JournalHeaderView
        if (DataMgr.instance().getNumJournalEntries() != 0) {
            header?.configure(text: DataMgr.instance().getJournalEntry(section: section, row: 0).getDateStr())
        }
        return header
    }
}
