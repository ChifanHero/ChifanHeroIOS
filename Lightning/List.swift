//
//  List.swift
//  Lightning
//
//  Created by Shi Yan on 8/5/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class List: Model{
    
    var id: String?
    var name: String?
    var memberCount: Int?
    var picture: Picture?
    var dishes: [Dish] = [Dish]()
    var likeCount: Int?
    var favoriteCount: Int?
    
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        id <-- data["id"]
        name <-- data["name"]
        memberCount <-- data["member_count"]
        picture <-- data["picture"]
        if let members = data["dishes"] as? [AnyObject] {
            for dish in members {
                let result = Dish(data: dish as! [String : AnyObject])
                dishes.append(result)
            }
        }
        likeCount <-- data["like_count"]
        favoriteCount <-- data["favorite_count"]
    }
}