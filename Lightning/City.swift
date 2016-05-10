//
//  State.swift
//  Lightning
//
//  Created by Shi Yan on 5/9/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class City : Model{
    
    var zip: String?
    var name: String?
    var state: String?
    var center: Location?
    var localizedCountryName: String?
    var activated : Bool?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        zip <-- data["zip"]
        name <-- data["name"]
        state <-- data["state"]
        center <-- data["center"]
        localizedCountryName <-- data["localized_country_name"]
        activated <-- data["activated"]
    }
    
}
