//
//  List.swift
//  SoHungry
//
//  Created by Shi Yan on 8/5/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class List : Model{
    
    var id : String?
    var name : String?
    var favoriteCount : Int?
    var likeCount : Int?
    var memberCount : Int?
    
    required init(data: [String : AnyObject]) {
        id <-- data["id"]
        name <-- data["name"]
        favoriteCount <-- data["favorite_count"]
        likeCount <-- data["like_count"]
        memberCount <-- data["member_count"]
    }
}