//
//  Filters.swift
//  Lightning
//
//  Created by Shi Yan on 8/7/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class Filters: Serializable {
    var range : Range?
    var minRating : Float?
    
    func getProperties() -> [String : AnyObject] {
        var parameters = Dictionary<String, AnyObject>()
        parameters["range"] = range?.getProperties()
        parameters["min_rating"] = minRating
        return parameters
    }
}
