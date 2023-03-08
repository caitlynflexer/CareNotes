//
//  SecondViewController.swift
//  CareNotes
//
//  Created by Caitlyn Flexer on 2/15/23.
//

import UIKit

class NewEntryViewCont: UIViewController {
                    
    @IBOutlet weak var textView: UITextView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.text = ""
        textView.textColor = UIColor.black
        textView.becomeFirstResponder()
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.cgColor
        textView.keyboardType = UIKeyboardType.default
        
        let saveButtonItem = UIBarButtonItem.init(title: "Save", style: .done, target: self, action: "saveBtnClicked:")
        saveButtonItem.isEnabled = false
        self.navigationItem.rightBarButtonItem = saveButtonItem
        
        let backButtonItem = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: "back:")
        self.navigationItem.leftBarButtonItem = backButtonItem
        
        self.navigationItem.title = "New Journal Entry"
    }
    

    @IBAction func saveBtnClicked(_ sender: UIBarButtonItem) {
        save()
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        goBack()
    }

    
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func save() {
        var date = Date.now
//        if (DataMgr.instance().getNumSections() == 0) {
//            date = Date.yesterday
//        }
        
        let journalEntry = JournalEntry(_text: textView.text.trim(), _user: DataMgr.instance().getCurrentUser()!.getUserName(), _dateAndTime: date, _vitals: [:], _symptoms: [])
        DataMgr.instance().addJournalEntry(entry: journalEntry)
        goBack()
    }
}

extension NewEntryViewCont: UITextViewDelegate {

    public func textViewDidChange(_ textView: UITextView) {
        if (!textView.text.trim().isEmpty) {
            self.navigationItem.rightBarButtonItem!.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem!.isEnabled = false
        }
    }
}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
}
