//
//  Location.swift
//  SoHungry
//
//  Created by Shi Yan on 12/3/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class Location: Serializable, Model {
    
    var lat: Double?
    var lon: Double?
    
    func getProperties() -> [String : AnyObject] {
        var parameters = Dictionary<String, AnyObject>()
        parameters["lat"] = lat
        parameters["lon"] = lon
        return parameters
    }
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        lat <-- data["lat"]
        lon <-- data["lon"]
    }
}
