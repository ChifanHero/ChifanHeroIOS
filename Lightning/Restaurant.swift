//
//  Restaurant.swift
//  Lightning
//
//  Created by Shi Yan on 8/5/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class Restaurant: Model{
    
    var id: String?
    var name: String?
    var englishName: String?
    var picture: Picture?
    var address: String?
    var distance: Distance?
    var favoriteCount: Int?
    var likeCount: Int?
    var dislikeCount: Int?
    var neutralCount: Int?
    var phone: String?
    var hours: String?
    var hotDishes: [Dish]?
    var votes: Int?
    var dishes: [String]?
    var rating: Double?
    
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
        dislikeCount <-- data["dislike_count"]
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
        dishes <-- data["dishes"]
        votes <-- data["votes"]
        rating <-- data["rating"]
    }
}
