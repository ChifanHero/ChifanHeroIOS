//
//  Dish.swift
//  SoHungry
//
//  Created by Shi Yan on 8/5/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class Dish : Model{
    
    var id : String?
    var name : String?
    var picture : Picture?
    var englishName : String?
    var favoriteCount : Int?
    var likeCount : Int?
    var dislikeCount : Int?
    var neutralCount : Int?
    var fromRestaurant : Restaurant?
    
    required init(data: [String : AnyObject]) {
        id <-- data["id"]
        name <-- data["name"]
        picture <-- data["picture"]
        englishName <-- data["english_name"]
        favoriteCount <-- data["favorite_count"]
        likeCount <-- data["like_count"]
        dislikeCount <-- data["dislike_count"]
        neutralCount <-- data["neutral_count"]
        fromRestaurant <-- data["from_restaurant"]
    }
}