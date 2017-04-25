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
    
    required init() {
        
    }
    
    required init(data: JSON) {
        id = data["id"].string
        userName = data["username"].string
        emailVerified = data["emailVerified"].bool
        email = data["email"].string
        nickName = data["nick_name"].string
        picture = Picture(data: data["picture"])
    }
}
