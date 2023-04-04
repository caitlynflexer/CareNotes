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
    private var min : Int
    private var max : Int
    
    init(_vitalName: String, _units: String, _min: Int, _max: Int) {
        vitalName = _vitalName
        units = _units
        min = _min
        max = _max
    }
    
    init(vitalInfo: [String : Any]) {
        vitalName = vitalInfo["vital"] as! String
        units = vitalInfo["units"] as! String
        min = vitalInfo["min"] == nil ? 0 : vitalInfo["min"] as! Int
        max = vitalInfo["max"] == nil ? 0 : vitalInfo["max"] as! Int
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
    
    public func getMin() -> Int {
        return min
    }
    
    public func getMax() -> Int {
        return max
    }
    
    public func setMin(newMin : Int) {
        min = newMin
        DataMgr.instance().dataChanged()
    }
    
    public func setMax(newMax : Int) {
        max = newMax
        DataMgr.instance().dataChanged()
    }
    
    public func export() -> [String : Any] {
        let dict : [String : Any] = ["vital" : vitalName, "units" : units, "min" : min, "max" : max]
        return dict
    }
    
}
