//
//  AddNewSymptomViewController.swift
//  CareNotes
//
//  Created by Caitlyn Flexer on 2/19/23.
//

import UIKit

class AddNewSymptomViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var symptomTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Add New Symptom"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action:#selector(NewVitalsTableViewController.back(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Save", style: .done, target: self, action:#selector(NewVitalsTableViewController.saveBtnClicked(_:)))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        symptomTextField.becomeFirstResponder()
        symptomTextField.addTarget(self, action: #selector(SetupViewCont.textFieldDidChange(_:)), for: .editingChanged)
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
        let newSymptom = symptomTextField.text?.trim()
        if (!newSymptom!.isEmpty) {
            DataMgr.instance().addSymptom(symptom: newSymptom!)
        }
        goBack()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if (!textField.text!.trim().isEmpty) {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }

}


