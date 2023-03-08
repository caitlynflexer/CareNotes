//
//  User.swift
//  CareNotes
//
//  Created by Caitlyn Flexer on 2/17/23.
//

import Foundation

public enum UserRole: String {
    case admin = "Admin"
    case careRecipient = "Care Recipient"
    case caregiver = "Caregiver"
}

public class User {
    private var name: String
    private var id: Int
    private var role: UserRole
    
    static var idCounter = 0
    
    init(_name: String, _role: UserRole) {
        name = _name
        id = User.idCounter
        role = _role
        
        User.idCounter += 1
    }
    
    init(userInfo: [String : Any]) {
        name = userInfo["name"] as! String
        role = UserRole(rawValue: userInfo["role"] as! String)!
        id = userInfo["id"] as! Int
    }
    
    public func getID() -> Int {
        return self.id
    }
    
    public func getUserName() -> String {
        return self.name
    }
    
    public func setUserName(newName : String) {
        name = newName
        DataMgr.instance().dataChanged()
    }
    
    public func getRole() -> String {
        return role.rawValue
    }
    
    public func isAdmin() -> Bool {
        return (role == UserRole.admin)
    }
    
    public func isCareRecipient() -> Bool {
        return (role == UserRole.careRecipient)
    }
    
    public func isCaregiver() -> Bool {
        return (role == UserRole.caregiver)
    }
    
    public func export() -> [String: Any] {
        let dict : [String : Any] = ["name" : name, "id" : id, "role" : role.rawValue]
        return dict
    }
    
    public static func setIDCounter(counter : Int) {
        idCounter = counter
    }
    
    
}
