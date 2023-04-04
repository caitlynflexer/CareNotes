//
//  DataMgr.swift
//  CareNotes
//
//  Created by Caitlyn Flexer on 2/16/23.
//

import Foundation

public class DataMgr {
    private var journalEntries: [JournalEntry] = []
    private var headerIndices = [Int]()
    private var users: [User] = []
    
    private var symptoms = ["Fatigue", "Leg pain", "Headache", "Fever", "Muscle cramps"]
    
    private var vitals = [Vital(_vitalName : "Weight", _units : "lbs", _min : 0, _max : 500), Vital(_vitalName : "O2 level", _units : "%", _min : 80, _max : 100), Vital(_vitalName : "Temperature", _units : "˚F", _min : 90, _max : 110), Vital(_vitalName : "Blood Pressure", _units : "mmHg", _min : 0, _max : 0)]
    
    private var careRecipientName: String = ""
    
    private var currentUserId: Int = 0
    
    private var inspectUserId: Int = 0
    private var inspectUserIndex: Int = 0
    
    private var inspectVitalIndex: Int = 0
    
    private static let dataMgr = DataMgr()
    
    init() {
        importFromFile()
    }
    
    static func instance() -> DataMgr {
        return dataMgr
    }
    
    private func updateHeaderIndices() {
        if (headerIndices.count == 0) {
            headerIndices.append(0)
        } else {
            let start = (journalEntries[0].getDateStr() == journalEntries[1].getDateStr()) ? 1 : 0
            if (start <= headerIndices.count - 1) {
                for i in start...headerIndices.count - 1{
                    headerIndices[i] += 1
                }
            }
            if (start == 0) {
                headerIndices.insert(0, at: 0)
            }
        }
    }

    func getJournalEntry(section: Int, row: Int) -> JournalEntry {
        let index = headerIndices[section] + row
        if (index < journalEntries.count) {
            return journalEntries[index]
        }
        else {
            return journalEntries[0]
        }
    }
    
    func getNumJournalEntries() -> Int {
        return journalEntries.count
    }
    
    func addJournalEntry(entry: JournalEntry) {
        journalEntries.insert(entry, at: 0)
        updateHeaderIndices()
        dataChanged()
    }
    
    func getNumUsers() -> Int {
        return users.count
    }
    
    func getUsers() -> [User] {
        return users
    }
    
    func addUser(user: User) {
        users.append(user)
        dataChanged()
    }
    
    func removeUser(index: Int) {
        users.remove(at: index)
        dataChanged()
    }
    
    func getUserById(id: Int) -> User? {
        if (users.count >= 1) {
            for i in 0...users.count - 1 {
                if users[i].getID() == id {
                    return users[i]
                }
            }
        }
        return nil
    }
    
    func getCurrentUser() -> User? {
        return getUserById(id: currentUserId) ?? nil
    }
    
    func getIndexOfUser(user : User) -> Int {
        for i in 0...users.count - 1 {
            if (user.getUserName() == users[i].getUserName()) {
                return i
            }
        }
        return -1
    }
    
    func setCurrentUserId(userId: Int) {
        currentUserId = userId
    }
    
    func setInspectVitalIndex(num : Int) {
        inspectVitalIndex = num
    }
    
    func getInspectVitalIndex() -> Int {
        return inspectVitalIndex
    }
    
    func setInspectUserId(userID: Int) {
        inspectUserId = userID
    }
    
    func getInspectUserId() -> Int {
        return inspectUserId
    }
    
    func setInspectUserIndex(index: Int) {
        inspectUserIndex = index
    }
    
    func getInspectUserIndex() -> Int {
        return inspectUserIndex
    }
    
    func getHighestUserID() -> Int {
        var maxUserID : Int = 0
        for user in users {
            if user.getID() > maxUserID {
                maxUserID = user.getID()
            }
        }
        return maxUserID
    }
    
    func setPatientName(name: String) {
        careRecipientName = name
        dataChanged()
    }
    
    func getPatientName() -> String {
        return(careRecipientName)
    }
    
    func addSymptom(symptom: String) {
        symptoms.append(symptom)
        dataChanged()
    }
    
    func getSymptoms() -> [String] {
        return symptoms
    }
    
    func removeSymptom(index: Int) {
        symptoms.remove(at: index)
        dataChanged()
    }
    
    func removeVital(index: Int) {
        vitals.remove(at: index)
        dataChanged()
    }
    
    func insertSymptom(symptom: String, index: Int) {
        symptoms.insert(symptom, at: index)
        dataChanged()
    }
    
    func insertVital(vital: Vital, index: Int) {
        vitals.insert(vital, at: index)
        dataChanged()
    }
    
    func addVitals(vital: Vital) {
        vitals.append(vital)
        dataChanged()
    }
    
    func getVitals() -> [Vital] {
        return vitals
    }
    
    func getVitalIndex(vital : String) -> Int {
        for i in 0...vitals.count - 1 {
            if (vitals[i].getVitalName() == vital) {
                return i
            }
        }
        return -1
    }
    
    func getVitalUnit(vital : String) -> String {
        for i in 0...vitals.count - 1 {
            if (vitals[i].getVitalName() == vital) {
                return vitals[i].getUnits()
            }
        }
        return ""
    }
    
    func getNumSections() -> Int {
        return headerIndices.count
    }
    
    func numRowsInSection(sectionIndex: Int) -> Int {
        if (sectionIndex < 0 || sectionIndex >= headerIndices.count) {
            // section index out of bounds
            return 0
        }
        if (headerIndices.count == 1) {
            // only one section
            return journalEntries.count
        }
        
        if (sectionIndex == headerIndices.count - 1) {
            // last section
            return journalEntries.count - headerIndices[sectionIndex]
        }
        
        // not the last section
        return headerIndices[sectionIndex + 1] - headerIndices[sectionIndex]
    }
    
    func rebuildHeaderIndicies() {
        headerIndices.removeAll()
        var prevDateStr : String = ""
        if (journalEntries.count > 0) {
            for i in 0...journalEntries.count - 1 {
                let curDateStr = journalEntries[i].getDateStr()
                if prevDateStr != curDateStr {
                    headerIndices.append(i)
                    prevDateStr = curDateStr
                }
            }
        }
    }
    
    func exportToJSONFile() {
        var userData : [Any] = []
        for user in users {
            userData.append(user.export())
        }
        
        var vitalsList : [Any] = []
        for vital in vitals {
            vitalsList.append(vital.export())
        }
        
        var journalData : [Any] = []
        for journal in journalEntries {
            journalData.append(journal.export())
        }
        
        let dict : [String: Any] = ["Users" : userData, "Symptoms":  symptoms, "Vitals" : vitalsList, "Journal Entries" : journalData, "Care Recipient Name" : careRecipientName]

        do {
            try
                JSONSerialization.save(jsonObject: dict, toFilename: "careNotesData")
        } catch {
            print("Unable to export")
        }
    }
    
    func dataChanged() {
        exportToJSONFile()
    }
    
    func importFromFile() -> Void {
        do {
            if let json = try JSONSerialization.loadJSON(withFilename: "careNotesData") as? Dictionary<String, Any> {
                
                if let symptomData = json["Symptoms"] as? [String] {
                    symptoms = symptomData
                }
                
                vitals.removeAll()
                if let vitalData = json["Vitals"] as? [Any] {
                    for vital in vitalData {
                        let vitalInfo : [String : Any] = vital as! [String : Any]
                        vitals.append(Vital (vitalInfo: vitalInfo))
                    }
                }
                
                if let careRecipientNameData = json["Care Recipient Name"] as? String {
                    careRecipientName = careRecipientNameData
                }
                
                journalEntries.removeAll()
                if let journalData = json["Journal Entries"] as? [Any] {
                    for journal in journalData {
                        let journalInfo : [String : Any?] = journal as! [String : Any?]
                        journalEntries.append(JournalEntry(journalInfo: journalInfo))
                    }
                }
                
                users.removeAll()
                if let userData = json["Users"] as? [Any] {
                    for user in userData {
                        let userInfo : [String : Any] = user as! [String : Any]
                        users.append(User (userInfo: userInfo))
                    }
                }
                User.setIDCounter(counter: getHighestUserID() + 1)
                
                rebuildHeaderIndicies()
            }
        } catch {
            print("Unable to import")
        }
    }
}


