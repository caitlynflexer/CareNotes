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
        
        symptomTextField.addTarget(self, action: #selector(AddNewSymptomViewController.textFieldDidChange(_:)), for: .editingChanged)
        
        self.navigationItem.scaleText();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        symptomTextField.becomeFirstResponder()
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
        
        let symptoms = DataMgr.instance().getSymptoms()
        var symptomExists = false
        
        for symptom in symptoms {
            if (symptom == newSymptom) {
                showDialog()
                symptomExists = true
            }
        }
        
        if (symptomExists == false) {
            if (!newSymptom!.isEmpty) {
                DataMgr.instance().addSymptom(symptom: newSymptom!)
            }
            goBack()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.navigationItem.rightBarButtonItem?.isEnabled = !textField.text!.trim().isEmpty
    }
    
    func showDialog() {
        let alert = UIAlertController(title: nil, message: "Symptom already exists. Please add a different symptom.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}


