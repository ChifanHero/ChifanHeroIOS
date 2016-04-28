//
//  OutputParams.swift
//  SoHungry
//
//  Created by Shi Yan on 12/3/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class OutputParams: Serializable{
    
    var distanceUnit: String?
    
    func getProperties() -> [String : AnyObject] {
        var properties = Dictionary<String, String>()
        properties["distance_unit"] = distanceUnit
        return properties
    }
    
}
