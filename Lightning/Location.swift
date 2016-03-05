//
//  Location.swift
//  SoHungry
//
//  Created by Shi Yan on 12/3/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class Location: Serializable {
    
    var lat : Double?
    var lon : Double?
    
    func getProperties() -> [String : Double] {
        var parameters = Dictionary<String, Double>()
        parameters["lat"] = lat
        parameters["lon"] = lon
        return parameters
    }
}
