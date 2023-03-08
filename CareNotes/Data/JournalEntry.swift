//
//  JournalEntry.swift
//  CareNotes
//
//  Created by Caitlyn Flexer on 2/17/23.
//

import Foundation

public class JournalEntry {
    private var text: String
    private var user: String
    private var dateAndTime: Date
    private var vitals: [String: String]
    private var symptoms: [String]
    
    let formatter = DateFormatter()
    
    init(_text: String, _user: String, _dateAndTime: Date, _vitals: [String:String], _symptoms: [String]) {
        text = _text
        user = _user
        dateAndTime = _dateAndTime
        vitals = _vitals
        symptoms = _symptoms
    }
    
    init(journalInfo: [String : Any]) {
        let dateTimeStr : String = journalInfo["dateAndTime"] as! String
        dateAndTime = dateTimeStr.toDate(withFormat : "MM/dd/yyyy HH:mm:ss")!
        
        text = ""
        if journalInfo["text"] != nil {
            text = journalInfo["text"] as! String
        }
        
        user = journalInfo["user"] as! String

        vitals = [:]
        if journalInfo["vitals"] != nil {
            vitals = journalInfo["vitals"] as! [String:String]
        }

        symptoms = []
        if journalInfo["symptoms"] != nil {
            symptoms = journalInfo["symptoms"] as! [String]
        }
    }
    func getUser() -> String {
        return self.user
    }
    
    func getTimeStr() -> String {
        formatter.timeStyle = .short
        return(formatter.string(from: dateAndTime))
    }
    
    func getDateStr() -> String {
        formatter.dateFormat = "MM/dd/yyyy"
        return(formatter.string(from: dateAndTime))
    }
    
    func getDateAndTimeStr() -> String {
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        return(formatter.string(from: dateAndTime))
    }
    
    func getDisplayText() -> String {
        var displayText = ""
        
        if (!text.isEmpty) {
            displayText = text
        }
        if (vitals.count > 0) {
            var vitalsString = ""
            let numVitals = DataMgr.instance().getVitals().count
            for i in 0...numVitals - 1 {
                let vital = DataMgr.instance().getVitals()[i]
                let value : String = vitals[vital] ?? ""
                if (!value.isEmpty) {
                    if (!vitalsString.isEmpty) {
                        vitalsString += ", "
                    }
                    vitalsString += vital + ": " + value
                }
            }
            if (!vitalsString.isEmpty) {
                if (!displayText.isEmpty) {
                    displayText += "\n"
                }
                displayText += vitalsString
            }
        }
        if (symptoms.count > 0) {
            if (!displayText.isEmpty) {
                displayText += "\n"
            }
            displayText += symptoms.joined(separator: ", ")
        }
        
        return displayText
    }
    
    public func export() -> [String: Any] {
        var dict : [String : Any] = ["user" : user, "dateAndTime" : getDateAndTimeStr()]
        
        if (!text.isEmpty) {
            dict["text"] = text
        }
        
        if (vitals.count > 0) {
            dict["vitals"] = vitals
        }
        
        if (symptoms.count > 0) {
            dict["symptoms"] = symptoms
        }
            
        return dict
    }
    
    public func importData() {
        print("hi")
    }
}
