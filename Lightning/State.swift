//
//  City.swift
//  Lightning
//
//  Created by Shi Yan on 5/9/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class State : Model{
    
    var name: String?
    var localizedCountryName: String?
    var abbr: String?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        name <-- data["name"]
        localizedCountryName <-- data["localized_country_name"]
        abbr <-- data["abbr"]
    }
    
}
