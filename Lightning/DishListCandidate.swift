//
//  DishListCandidate.swift
//  Lightning
//
//  Created by Shi Yan on 2/27/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class DishListCandiate : Model {
    var id : String?
    var dish : Dish?
    var list : List?
    var count : Int?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        id <-- data["id"]
        dish <-- data["dish"]
        list <-- data["list"]
        count <-- data["count"]
    }
}
