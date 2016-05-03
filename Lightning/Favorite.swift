//
//  Favorite.swift
//  Lightning
//
//  Created by Shi Yan on 8/16/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class Favorite: Model {
    
    var id: String?
    var user: User?
    var dish: Dish?
    var restaurant: Restaurant?
    var selectedCollection: SelectedCollection?
    var type: String?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        id <-- data["id"]
        user <-- data["user"]
        dish <-- data["dish"]
        restaurant <-- data["restaurant"]
        selectedCollection <-- data["selected_collection"]
        type <-- data["type"]
    }
}
