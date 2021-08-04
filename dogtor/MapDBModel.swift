//
//  MapDBModel.swift
//  dogtor
//
//  Created by SeungYeon on 2021/08/03.
//

import Foundation

class MapDBModel: NSObject{
    var HospitalID: String?
    var HospitalName: String?
    var Location: String?
    var Lat: String?
    var Long: String?
    
    // Empty constructor
    override init() {
        
    }
    
    init(HospitalID: String, HospitalName: String, Location: String, Lat: String, Long: String) {
        self.HospitalID = HospitalID
        self.HospitalName = HospitalName
        self.Location = Location
        self.Lat = Lat
        self.Long = Long
        
    }
}
