//
//  Dish.swift
//  Lightning
//
//  Created by Shi Yan on 8/5/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class Dish: Model{
    
    var id: String?
    var name: String?
    var picture: Picture?
    var englishName: String?
    var favoriteCount: Int?
    var likeCount: Int?
    var dislikeCount: Int?
    var neutralCount: Int?
    var fromRestaurant: Restaurant?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        id = data["id"].string
        name = data["name"].string
        picture = Picture(data: data["picture"])
        englishName = data["english_name"].string
        favoriteCount = data["favorite_count"].int
        likeCount = data["like_count"].int
        dislikeCount = data["dislike_count"].int
        neutralCount = data["neutral_count"].int
        fromRestaurant = Restaurant(data: data["from_restaurant"])
    }
}
