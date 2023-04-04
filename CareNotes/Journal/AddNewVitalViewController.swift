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
    @IBOutlet weak var minTextField: UITextField!
    @IBOutlet weak var maxTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Add New Vital"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action:#selector(NewVitalsTableViewController.back(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Save", style: .done, target: self, action:#selector(NewVitalsTableViewController.saveBtnClicked(_:)))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        vitalTextField.addTarget(self, action: #selector(AddNewVitalViewController.textFieldDidChange(_:)), for: .editingChanged)
        unitsTextField.addTarget(self, action: #selector(AddNewVitalViewController.textFieldDidChange(_:)), for: .editingChanged)
        minTextField.addTarget(self, action: #selector(AddNewVitalViewController.textFieldDidChange(_:)), for: .editingChanged)
        maxTextField.addTarget(self, action: #selector(AddNewVitalViewController.textFieldDidChange(_:)), for: .editingChanged)

        
        self.navigationItem.scaleText();
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
        let newMin = minTextField.text != "" ? minTextField.text?.trim() : ""
        let newMax = maxTextField.text != "" ? maxTextField.text?.trim() : ""

        let vitals = DataMgr.instance().getVitals()
        var vitalExists = false
        var hasValidConstraints = true
        var hasConstraints = false
        
        for vital in vitals {
            if (vital.getVitalName() == newVital) {
                showDialog(message: "Vital already exists. Please add a different vital.")
                vitalExists = true
            }
        }
        
        if ((!newMin!.isNumber && newMin != "") || (newMin == "" && newMax != "")) {
            showDialog(message: "Please enter an integer for min value.")
            hasValidConstraints = false
        } else if ((!newMax!.isNumber && newMax != "") || (newMax == "" && newMin != "")) {
            showDialog(message: "Please enter an integer for max value.")
            hasValidConstraints = false
        } else if (newMax!.isNumber && newMin!.isNumber) {
            if (Int(newMax!)! < Int(newMin!)!) {
                showDialog(message: "Max value must be greater than or equal to min value.")
                hasValidConstraints = false
            } else {
                hasValidConstraints = true
                hasConstraints = true
            }
        }
        
        
        if (vitalExists == false) {
            if (hasValidConstraints) {
                if (hasConstraints) {
                    DataMgr.instance().addVitals(vital: Vital(_vitalName : newVital, _units : newUnit!, _min : Int(newMin!)!, _max : Int(newMax!)!))
                } else {
                    DataMgr.instance().addVitals(vital: Vital(_vitalName : newVital, _units : newUnit!, _min : 0, _max : 0))
                }
                goBack()
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.navigationItem.rightBarButtonItem?.isEnabled = !vitalTextField.text!.trim().isEmpty
    }
    
    func showDialog(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


