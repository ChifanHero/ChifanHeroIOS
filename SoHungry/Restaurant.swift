//
//  Restaurant.swift
//  SoHungry
//
//  Created by Shi Yan on 8/5/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class Restaurant : Model{
    
    var id : String?
    var name : String?
    var englishName : String?
    var picture : Picture?
    var address : String?
    var distance : String?
    var favoriteCount : Int?
    var likeCount : Int?
    var dislikeCount : Int?
    var neutralCount : Int?
    var phone : String?
    var hours : String?
    var hotDishes : [Dish]?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        id <-- data["id"]
        name <-- data["name"]
        englishName <-- data["english_name"]
        picture <-- data["picture"]
        address <-- data["address"]
        distance <-- data["distance"]
        favoriteCount <-- data["favorite_count"]
        likeCount <-- data["like_count"]
        neutralCount <-- data["neutral_count"]
        phone <-- data["phone"]
        hours <-- data["hours"]
        if let resultsJson = data["hot_dishes"] as? [AnyObject] {
            hotDishes = [Dish]()
            for resultJson in resultsJson {
                let result = Dish(data: resultJson as! [String : AnyObject])
                hotDishes?.append(result)
            }
        }
    }
}