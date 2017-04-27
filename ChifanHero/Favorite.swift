//
//  Favorite.swift
//  Lightning
//
//  Created by Shi Yan on 8/16/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class Favorite: Model {
    
    var id: String?
    var user: User?
    var dish: Dish?
    var restaurant: Restaurant?
    var selectedCollection: SelectedCollection?
    var type: String?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        id = data["id"].string
        if(data["user"].exists()){
            user = User(data: data["user"])
        }
        if(data["dish"].exists()){
            dish = Dish(data: data["dish"])
        }
        if(data["restaurant"].exists()){
            restaurant = Restaurant(data: data["restaurant"])
        }
        if(data["selected_collection"].exists()){
            selectedCollection = SelectedCollection(data: data["selected_collection"])
        }
        type = data["type"].string
    }
}
