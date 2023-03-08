//
//  JournalTableViewController.swift
//  CareNotes
//
//  Created by Caitlyn Flexer on 2/18/23.
//

import UIKit

class JournalTableViewController: UITableViewController {
    
    let quoteCellReuseIdentifier = "quoteCellReuseIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()

        // top bar
        self.navigationItem.title = "Journal for " + DataMgr.instance().getPatientName()
        
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
        tableView.register(UINib(nibName: String(describing: QuoteTableViewCell.self), bundle: nil), forCellReuseIdentifier: quoteCellReuseIdentifier)
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
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return DataMgr.instance().getNumSections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataMgr.instance().numRowsInSection(sectionIndex: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: quoteCellReuseIdentifier, for: indexPath) as! QuoteTableViewCell
        
        let journalEntry = DataMgr.instance().getJournalEntry(section: indexPath.section, row: indexPath.row)
        cell.userLabel?.text = journalEntry.getUser()
        cell.journalEntry?.text = journalEntry.getDisplayText()
        cell.time?.text = journalEntry.getTimeStr()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: JournalHeaderView.identifier) as? JournalHeaderView
        header?.configure(text: DataMgr.instance().getJournalEntry(section: section, row: 0).getDateStr())
        return header
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
