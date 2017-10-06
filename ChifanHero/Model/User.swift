//
//  User.swift
//  Lightning
//
//  Created by Shi Yan on 8/5/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class User: Model{
    
    var id: String?
    var userName: String?
    var emailVerified: Bool?
    var email: String?
    var nickName: String?
    var picture: Picture?
    var password: String?
    var usingDefaultUsername: Bool?
    var usingDefaultPassword: Bool?
    var usingDefaultNickname: Bool?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        id = data["id"].string
        userName = data["username"].string
        emailVerified = data["email_verified"].bool
        email = data["email"].string
        nickName = data["nick_name"].string
        password = data["password"].string
        if data["picture"].exists() {
            picture = Picture(data: data["picture"])
        }
        usingDefaultUsername = data["using_default_username"].bool
        usingDefaultPassword = data["using_default_password"].bool
        usingDefaultNickname = data["using_default_nickname"].bool
    }
}
