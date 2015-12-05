//
//  Distance.swift
//  SoHungry
//
//  Created by Shi Yan on 12/3/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class Distance: Serializable {
    
    var value : Double?
    var unit : String?
    
    func getProperties() -> [String : AnyObject] {
        var parameters = Dictionary<String, AnyObject>()
        parameters["value"] = value
        parameters["unit"] = unit
        return parameters
    }
}
