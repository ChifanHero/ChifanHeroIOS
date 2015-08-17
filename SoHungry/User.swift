//
//  User.swift
//  SoHungry
//
//  Created by Shi Yan on 8/5/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class User : Model{
    
    var id : String?
    var userName : String?
    var emailVerified : Bool?
    var email : String?
    var favoriteCuisine : [String]?
    var level : Int?
    var nickName : String?
    var picture : Picture?
    
    required init(data: [String : AnyObject]) {
        id <-- data["id"]
        userName <-- data["username"]
        emailVerified <-- data["emailVerified"]
        email <-- data["email"]
        favoriteCuisine <-- data["favorite_cuisine"]
        level <-- data["level"]
        nickName <-- data["nick_name"]
        picture <-- data["picture"]
    }
}
