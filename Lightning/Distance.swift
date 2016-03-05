//
//  Distance.swift
//  SoHungry
//
//  Created by Shi Yan on 12/3/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class Distance: Serializable, Model{
    
    var value : Double?
    var unit : String?
    
    func getProperties() -> [String : AnyObject] {
        var parameters = Dictionary<String, AnyObject>()
        parameters["value"] = value
        parameters["unit"] = unit
        return parameters
    }
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        value <-- data["value"]
        unit <-- data["unit"]
    }
}
