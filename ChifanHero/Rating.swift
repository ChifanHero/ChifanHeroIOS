//
//  Review.swift
//  Lightning
//
//  Created by Shi Yan on 8/16/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class Rating: Model {
    
    var id: String?
    var type: String?
    var action: String?
    var user: User?
    var dish: Dish?
    var restaurant: Restaurant?
    
    required init() {
       
    }
    
    required init(data: JSON) {
        id = data["id"].string
        type = data["type"].string
        action = data["action"].string
        if(data["user"].exists()){
            user = User(data: data["user"])
        }
        if(data["dish"].exists()){
            dish = Dish(data: data["dish"])
        }
        if(data["restaurant"].exists()){
            restaurant = Restaurant(data: data["restaurant"])
        }
    }
}
