//
//  Range.swift
//  SoHungry
//
//  Created by Shi Yan on 12/3/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class Range: Serializable{
    
    var center: Location?
    var distance: Distance?
    
    func getProperties() -> [String : AnyObject] {
        var parameters = Dictionary<String, AnyObject>()
        parameters["center"] = center?.getProperties()
        parameters["distance"] = distance?.getProperties()
        return parameters
    }
    
}
