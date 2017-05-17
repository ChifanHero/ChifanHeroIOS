//
//  Distance.swift
//  SoHungry
//
//  Created by Shi Yan on 12/3/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation
import SwiftyJSON

class Distance: Serializable, Model{
    
    var value: Double?
    var unit: String?
    
    func getProperties() -> [String : AnyObject] {
        var parameters = Dictionary<String, AnyObject>()
        parameters["value"] = value as AnyObject
        parameters["unit"] = unit as AnyObject
        return parameters
    }
    
    required init() {
        
    }
    
    required init(data: JSON) {
        value = data["value"].double
        unit = data["unit"].string
    }
}
