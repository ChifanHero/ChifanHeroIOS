//
//  OauthLoginResponse.swift
//  Lightning
//
//  Created by Zhang, Alex on 6/21/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class OauthLoginResponse: Model {
    
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
