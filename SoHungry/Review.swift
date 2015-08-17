//
//  Review.swift
//  SoHungry
//
//  Created by Shi Yan on 8/16/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class Review : Model {
    
    var id : String?
    var type : String?
    var action : String?
    var user : User?
    var dish : Dish?
    var restaurant : Restaurant?
    var list : List?
    
    required init(data: [String : AnyObject]) {
        id <-- data["id"]
        type <-- data["type"]
        action <-- data["action"]
        user <-- data["user"]
        dish <-- data["dish"]
        restaurant <-- data["restaurant"]
        list <-- data["list"]
    }
}
