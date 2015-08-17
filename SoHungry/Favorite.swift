//
//  Favorite.swift
//  SoHungry
//
//  Created by Shi Yan on 8/16/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class Favorite: Model {
    
    var id : String?
    var user : User?
    var dish : Dish?
    var restaurant : Restaurant?
    var list : List?
    var type : String?
    
    required init(data: [String : AnyObject]) {
        id <-- data["id"]
        user <-- data["user"]
        dish <-- data["dish"]
        restaurant <-- data["restaurant"]
        list <-- data["list"]
        type <-- data["type"]
    }
}
