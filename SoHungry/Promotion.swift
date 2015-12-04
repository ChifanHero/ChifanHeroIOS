//
//  Promotion.swift
//  SoHungry
//
//  Created by Shi Yan on 8/5/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class Promotion : Model{
    
    var id: String?
    var type: String?
    var restaurant: Restaurant?
    var dish: Dish?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        id <-- data["id"]
        type <-- data["type"]
        restaurant <-- data["restaurant"]
        dish <-- data["dish"]
    }
}