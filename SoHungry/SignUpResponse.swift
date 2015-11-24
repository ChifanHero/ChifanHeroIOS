//
//  SignUpResponse.swift
//  SoHungry
//
//  Created by Zhang, Alex on 11/3/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class SignUpResponse: Model {
    
    var success: Bool?
    var sessionToken: String?
    var user: User?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        success <-- data["success"]
        sessionToken <-- data["session_token"]
        user <-- data["user"]
    }
    
}