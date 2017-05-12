//
//  State.swift
//  Lightning
//
//  Created by Shi Yan on 5/9/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class City : Model{
    
    var zip: String?
    var name: String?
    var state: String?
    var center: Location?
    var localizedCountryName: String?
    var activated : Bool?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        zip = data["zip"].string
        name = data["name"].string
        state = data["state"].string
        if(data["center"].exists()){
            center = Location(data: data["center"])
        }
        localizedCountryName = data["localized_country_name"].string
        activated = data["activated"].bool
    }
    
}
