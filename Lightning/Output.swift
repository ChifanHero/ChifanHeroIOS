//
//  Output.swift
//  SoHungry
//
//  Created by Shi Yan on 12/3/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class Output: Serializable {
    
    var fields: [String]?
    var params: OutputParams?
    
    func getProperties() -> [String : AnyObject] {
        var parameters = Dictionary<String, AnyObject>()
        parameters["fields"] = fields as AnyObject
        parameters["params"] = params?.getProperties() as AnyObject
        return parameters
    }
}
