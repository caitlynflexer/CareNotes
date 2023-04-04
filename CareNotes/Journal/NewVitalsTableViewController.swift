//
//  NewVitalsTableViewController.swift
//  CareNotes
//
//  Created by Caitlyn Flexer on 2/18/23.
//

import UIKit

class NewVitalsTableViewController: UITableViewController {
    private var selectedSymptoms : [String] = []
    private var vitalValues = [String: String]()
    
    private var editMode = false
    private var titleHdr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // top bar
        self.navigationItem.title = "New Vitals"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action:#selector(NewVitalsTableViewController.back(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Save", style: .done, target: self, action:#selector(NewVitalsTableViewController.saveBtnClicked(_:)))

        // table view
        tableView.isEditing = true
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.register(JournalHeaderView.self, forHeaderFooterViewReuseIdentifier: JournalHeaderView.identifier)
        
        self.navigationItem.scaleText();
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
        let selectedRows = tableView.indexPathsForSelectedRows
        let haveSelectedRows = (selectedRows != nil) && selectedRows!.count >= 1
        
        if (haveSelectedRows || vitalValues.count > 0) {
            if (haveSelectedRows) {
                for indexPath in selectedRows! {
                    if (indexPath.section == 1) {
                        let cell = tableView.cellForRow(at: indexPath)
                        selectedSymptoms.append((cell?.textLabel?.text)!)
                    }
                }
            }
            
            let date = Date.now
            
            if (vitalValues.count > 0) {
                for (vitalName, value) in vitalValues {
                    if (value == "") {
                        vitalValues.removeValue(forKey: vitalName)
                    }
                }
            }
            
            if (selectedSymptoms.count > 0 || vitalValues.count > 0) {
                let journalEntry = JournalEntry(_text: "", _user: DataMgr.instance().getCurrentUser()!.getUserName(), _dateAndTime: date, _vitals: vitalValues, _symptoms: selectedSymptoms)
                    DataMgr.instance().addJournalEntry(entry: journalEntry)
            }
        }
        goBack()
    }
    
    @objc public func textFieldDidChange(_ textField: UITextField) {
        // store new value every on key stroke
        let vital : String = textField.accessibilityIdentifier!
        var value : String = textField.text?.trim() ?? ""
        if (value != "") {
            value += " " + DataMgr.instance().getVitalUnit(vital: vital)
        }
        self.vitalValues[vital] = value
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section ==  1) {
            dismissKeyboard()
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if (indexPath.section ==  1) {
            dismissKeyboard()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? DataMgr.instance().getVitals().count : DataMgr.instance().getSymptoms().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var viewCell : UITableViewCell
        
        if (indexPath.section == 0) {
            let vitalCell = tableView.dequeueReusableCell(withIdentifier: "vitalCell", for: indexPath)
            
            if (DataMgr.instance().getVitals()[indexPath.row].getUnits() != "") {
                vitalCell.textLabel?.text = DataMgr.instance().getVitals()[indexPath.row].getVitalName() + " (" + DataMgr.instance().getVitals()[indexPath.row].getUnits() + "): "
            } else {
                vitalCell.textLabel?.text = DataMgr.instance().getVitals()[indexPath.row].getVitalName()
            }
            vitalCell.selectionStyle = .none
            
            if (editMode) {
                vitalCell.contentView.subviews[0].isHidden = true
            } else {
                vitalCell.contentView.subviews[0].isHidden = false
                let textField:UITextField = vitalCell.contentView.subviews[0] as! UITextField
                
                let vital = DataMgr.instance().getVitals()[indexPath.row].getVitalName()
                textField.accessibilityIdentifier = vital
                
                
                if let vitalStr = vitalValues[vital] {
                    if vitalStr != "" {
                        let units = DataMgr.instance().getVitals()[indexPath.row].getUnits()
                        let endIndex = vitalStr.count - units.count - 1
                        textField.text = String(vitalStr.prefix(endIndex))
                    }
                } else {
                    textField.text = ""
                }
                
                textField.addTarget(self, action: #selector(NewVitalsTableViewController.textFieldDidChange(_:)), for: .editingChanged)
                textField.keyboardType = UIKeyboardType.numbersAndPunctuation
            }
            
            if (UIDevice.isPad) {
                vitalCell.textLabel?.font = UIFont.init(name: "Helvetica", size: 22)
            }
            
            viewCell = vitalCell
            
        } else {
            let symptomCell = tableView.dequeueReusableCell(withIdentifier: "symptomCell", for: indexPath)
            symptomCell.textLabel?.text = DataMgr.instance().getSymptoms()[indexPath.row]
            if (UIDevice.isPad) {
                symptomCell.textLabel?.font = UIFont.init(name: "Helvetica", size: 22)
            }
            viewCell = symptomCell
        }
        
        for recognizer in viewCell.textLabel?.gestureRecognizers ?? [] {
            viewCell.textLabel?.removeGestureRecognizer(recognizer)
        }
        
        if (editMode) {
            let tap = UITapGestureRecognizer(target: self, action: indexPath.section == 0 ? #selector(NewVitalsTableViewController.vitalTapped) : #selector(NewVitalsTableViewController.symptomTapped))
            viewCell.textLabel?.tag = indexPath.row
            viewCell.textLabel?.isUserInteractionEnabled = true
            viewCell.textLabel?.addGestureRecognizer(tap)
        }
        else {
            viewCell.textLabel?.isUserInteractionEnabled = false
        }
        
        return viewCell
    }

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: JournalHeaderView.identifier) as? JournalHeaderView
        header?.configure(text: section == 0 ? "Vitals" : "Symptoms")
        
        
        if let hdr = header {
            
            for view in hdr.contentView.subviews {
                if (view is UIButton) {
                    view.removeFromSuperview()
                }
            }
            
            // add plus button to header
            let plusBtn: UIButton = UIButton()
            plusBtn.setImage(UIImage(systemName: "plus"), for: .normal)
            plusBtn.addTarget(self, action: #selector(self.newBtnClicked(_:)), for: .touchUpInside)
            plusBtn.accessibilityIdentifier = (section == 0 ? "newVital" : "newSymptom")
            plusBtn.translatesAutoresizingMaskIntoConstraints = false
            hdr.contentView.addSubview(plusBtn);
            let margins = hdr.contentView.layoutMarginsGuide
            plusBtn.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0).isActive = true
            plusBtn.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0).isActive = true
            
            // add edit button to header
            if (section == 0) {
                let editBtn: UIButton = UIButton()
                if (editMode) {
                    editBtn.setImage(UIImage(systemName: "pencil.slash"), for: .normal)
                } else {
                    editBtn.setImage(UIImage(systemName: "pencil"), for: .normal)
                }
                editBtn.accessibilityIdentifier = (section == 0 ? "newVital" : "newSymptom")
                editBtn.addTarget(self, action: #selector(self.editBtnClicked(_:)), for: .touchUpInside)
                editBtn.translatesAutoresizingMaskIntoConstraints = false
                hdr.contentView.addSubview(editBtn);
                editBtn.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10).isActive = true
                editBtn.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0).isActive = true
            }
            
        }
        
        return header
    }
    
    @IBAction func newBtnClicked(_ sender: Any) {
        let btn = sender as? UIView
        if (btn?.accessibilityIdentifier == "newVital") {
            let newViewCont = self.storyboard?.instantiateViewController(withIdentifier: "AddNewVitalViewControllerID") as! AddNewVitalViewController
            self.navigationController?.pushViewController(newViewCont, animated: true)
        }
        else if (btn?.accessibilityIdentifier == "newSymptom") {
            let newViewCont = self.storyboard?.instantiateViewController(withIdentifier: "AddNewSymptomViewControllerID") as! AddNewSymptomViewController
            self.navigationController?.pushViewController(newViewCont, animated: true)
        }
    }
    
    @IBAction func editBtnClicked(_ sender: UIButton) {
        editMode = !editMode
        tableView.allowsMultipleSelectionDuringEditing = !editMode
        tableView.reloadData()
    }


    // Override to support conditional editing of the table view
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (editMode) {
            return true
        } else {
            return (indexPath.section == 1)
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if (editMode) {
            return .delete
        }
        return .none
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            if (indexPath.section == 0) {
                DataMgr.instance().removeVital(index: indexPath.row)
            } else {
                DataMgr.instance().removeSymptom(index: indexPath.row)
            }
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return (editMode)
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if (sourceIndexPath.section != proposedDestinationIndexPath.section ) {
            return sourceIndexPath
        } else {
            return proposedDestinationIndexPath
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if (sourceIndexPath.section == destinationIndexPath.section) {
            if (sourceIndexPath.section == 0) {
                let movedVital = DataMgr.instance().getVitals()[sourceIndexPath.row]
                DataMgr.instance().removeVital(index: sourceIndexPath.row)
                DataMgr.instance().insertVital(vital: movedVital, index: destinationIndexPath.row)
            } else {
                let movedObject = DataMgr.instance().getSymptoms()[sourceIndexPath.row]
                DataMgr.instance().removeSymptom(index: sourceIndexPath.row)
                DataMgr.instance().insertSymptom(symptom: movedObject, index: destinationIndexPath.row)
            }
        }
    }
    
    @objc func vitalTapped(sender:UITapGestureRecognizer) {
        if let view = sender.view {
            let row = view.tag
            DataMgr.instance().setInspectVitalIndex(num: row)
            print("vital tapped" + String(row))
        }
        
        let newViewCont = self.storyboard?.instantiateViewController(withIdentifier: "VitalDetailsTableViewControllerID") as! VitalDetailsTableViewController
        self.navigationController?.pushViewController(newViewCont, animated: true)
    }
        
    @objc func symptomTapped(sender:UITapGestureRecognizer) {
        if let view = sender.view {
            let row = view.tag
            print("symptom tapped" + String(row))
        }
    }
}
