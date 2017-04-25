//
//  City.swift
//  Lightning
//
//  Created by Shi Yan on 5/9/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class State : Model{
    
    var name: String?
    var localizedCountryName: String?
    var abbr: String?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        name = data["name"].string
        localizedCountryName = data["localized_country_name"].string
        abbr = data["abbr"].string
    }
    
}
