//
//  Location.swift
//  SoHungry
//
//  Created by Shi Yan on 12/3/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation
import SwiftyJSON

class Location: Serializable, Model {
    
    var lat: Double?
    var lon: Double?
    
    func getProperties() -> [String : AnyObject] {
        var parameters = Dictionary<String, AnyObject>()
        parameters["lat"] = lat as AnyObject
        parameters["lon"] = lon as AnyObject
        return parameters
    }
    
    required init() {
        
    }
    
    required init(data: JSON) {
        lat = data["lat"].double
        lon = data["lon"].double
    }
}
