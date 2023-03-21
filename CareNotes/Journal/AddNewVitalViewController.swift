//
//  AddNewVitalViewController.swift
//  CareNotes
//
//  Created by Caitlyn Flexer on 2/19/23.
//

import UIKit

class AddNewVitalViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var vitalTextField: UITextField!
    @IBOutlet weak var unitsTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Add New Vital"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action:#selector(NewVitalsTableViewController.back(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Save", style: .done, target: self, action:#selector(NewVitalsTableViewController.saveBtnClicked(_:)))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        vitalTextField.addTarget(self, action: #selector(AddNewVitalViewController.textFieldDidChange(_:)), for: .editingChanged)
        unitsTextField.addTarget(self, action: #selector(AddNewVitalViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        vitalTextField.becomeFirstResponder()
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
        let newVital = (vitalTextField.text?.trim())!
        let newUnit = unitsTextField.text != "" ? unitsTextField.text?.trim() : ""
        
        let vitals = DataMgr.instance().getVitals()
        var vitalExists = false
        
        for vital in vitals {
            if (vital.getVitalName() == newVital) {
                showDialog()
                vitalExists = true
            }
        }
        
        if (vitalExists == false) {
            DataMgr.instance().addVitals(vital: Vital(_vitalName : newVital, _units : newUnit!))
            goBack()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.navigationItem.rightBarButtonItem?.isEnabled = !vitalTextField.text!.trim().isEmpty
    }
    
    func showDialog() {
        let alert = UIAlertController(title: nil, message: "Vital already exists. Please add a different vital.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


