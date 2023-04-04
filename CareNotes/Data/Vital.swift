//
//  Vital.swift
//  CareNotes
//
//  Created by Caitlyn Flexer on 3/10/23.
//

import Foundation

public class Vital {
    
    private var vitalName : String
    private var units : String
    // private var min : Int
    // private var max : Int
    
    init(_vitalName: String, _units: String) {
        vitalName = _vitalName
        units = _units
    }
    
    init(vitalInfo: [String : Any]) {
        vitalName = vitalInfo["vital"] as! String
        units = vitalInfo["units"] as! String
    }
    
    public func getVitalName() -> String {
        return self.vitalName
    }
    
    public func setVitalName(name : String) {
        vitalName = name
        DataMgr.instance().dataChanged()
    }
    
    public func getUnits() -> String {
        return self.units
    }
    
    public func setUnits(newUnits : String) {
        units = newUnits
        DataMgr.instance().dataChanged()
    }
    
    public func export() -> [String : Any] {
        let dict : [String : Any] = ["vital" : vitalName, "units" : units]
        return dict
    }
    
}
