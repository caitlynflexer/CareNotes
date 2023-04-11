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
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.cgColor
        textView.keyboardType = UIKeyboardType.default
        
        if (UIDevice.isPad) {
            textView.font = UIFont(name: "Helvetica", size: 23)
        }
        
        let saveButtonItem = UIBarButtonItem.init(title: "Save", style: .done, target: self, action: #selector(self.saveBtnClicked(_:)))
        saveButtonItem.isEnabled = false
        self.navigationItem.rightBarButtonItem = saveButtonItem
        
        let backButtonItem = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(self.back(_:)))
        self.navigationItem.leftBarButtonItem = backButtonItem
        
        self.navigationItem.title = "New Journal Entry"
        
        self.navigationItem.scaleText();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
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
        let journalEntry = JournalEntry(_text: textView.text.trim(), _user: DataMgr.instance().getCurrentUser()!.getUserName(), _dateAndTime: Date.now, _vitals: [:], _symptoms: [])
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

