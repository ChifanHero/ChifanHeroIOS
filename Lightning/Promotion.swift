//
//  Promotion.swift
//  Lightning
//
//  Created by Shi Yan on 8/5/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class Promotion : Model{
    
    var id: String?
    var restaurant: Restaurant?
    var dish: Dish?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        id <-- data["id"]
        restaurant <-- data["restaurant"]
        dish <-- data["dish"]
    }
}