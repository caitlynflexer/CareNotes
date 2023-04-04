//
//  VitalDetailsTableViewController.swift
//  CareNotes
//
//  Created by Caitlyn Flexer on 2/23/23.
//

import UIKit

class VitalDetailsTableViewController: UITableViewController {
    
    var editMode = false
    var nameChanged = false
    var unitsChanged = false
    
    let vitalIndex = DataMgr.instance().getInspectVitalIndex()
    var vitalName = ""
    var vitalUnits = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        vitalName = DataMgr.instance().getVitals()[vitalIndex].getVitalName()
        vitalUnits = DataMgr.instance().getVitalUnit(vital: vitalName)
        
        self.navigationItem.title = "Vital Details"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Back", style: .plain, target: self, action:#selector(UserDetailsTableViewController.back(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Edit", style: .done, target: self, action:#selector(UserDetailsTableViewController.editBtnClicked(_:)))
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        
        self.navigationItem.scaleText();
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        goBack()
    }
    
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editBtnClicked(_ sender: UIBarButtonItem) {
        var vitalExists = false
        
        if (editMode) {
            let vitals = DataMgr.instance().getVitals()
            for i in 0...vitals.count - 1 {
                if (i != vitalIndex && vitals[i].getVitalName() == DataMgr.instance().getVitals()[vitalIndex].getVitalName()) {
                    showDialog()
                    vitalExists = true
                }
            }
        }
        
        if (vitalExists == false) {
            editMode = !editMode
            self.navigationItem.rightBarButtonItem!.title = editMode ? "Done" : "Edit"
            self.navigationItem.leftBarButtonItem?.isEnabled = editMode ? false : true
            tableView.reloadData()
        }
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @objc public func textFieldDidChange(_ textField: UITextField) {
        let property : String = textField.accessibilityIdentifier!
        let value : String = textField.text?.trim() ?? ""

        if (property == "Units") {
            DataMgr.instance().getVitals()[vitalIndex].setUnits(newUnits: value)
            vitalUnits = value
        }
        
        if (property == "Name") {
            DataMgr.instance().getVitals()[vitalIndex].setVitalName(name : value)
            vitalName = value
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if (indexPath.row == 0) {
            cell.textLabel?.textColor = .black
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.text = editMode ? "Vital:" : "Vital: " + vitalName
        } else {
            cell.textLabel?.text = editMode ? "Units:" : "Units: " + vitalUnits
        }
        
        if (UIDevice.isPad) {
            cell.textLabel?.font = UIFont.init(name: "Helvetica", size: 25)
        }
        
        if (editMode) {
            cell.contentView.subviews[0].isHidden = false
            let textField:UITextField = cell.contentView.subviews[0] as! UITextField
            textField.accessibilityIdentifier = (indexPath.row == 0) ? "Name" : "Units"
            textField.text = (indexPath.row == 0) ? vitalName : vitalUnits
            textField.addTarget(self, action: #selector(VitalDetailsTableViewController.textFieldDidChange(_:)), for: .editingChanged)
            textField.keyboardType = (indexPath.row == 0) ? UIKeyboardType.default : UIKeyboardType.numbersAndPunctuation
        } else {
            cell.contentView.subviews[0].isHidden = true
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showDialog() {
        let alert = UIAlertController(title: nil, message: "Vital already exists. Please choose a different vital name.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
