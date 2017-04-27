//
//  Promotion.swift
//  Lightning
//
//  Created by Shi Yan on 8/5/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class Promotion: Model{
    
    var id: String?
    var restaurant: Restaurant?
    var dish: Dish?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        id = data["id"].string
        if(data["restaurant"].exists()){
            restaurant = Restaurant(data: data["restaurant"])
        }
        if(data["dish"].exists()){
            dish = Dish(data: data["dish"])
        }
    }
}
