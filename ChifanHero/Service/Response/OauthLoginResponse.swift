//
//  OauthLoginResponse.swift
//  Lightning
//
//  Created by Zhang, Alex on 6/21/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class OauthLoginResponse: Model {
    
    var success: Bool?
    var sessionToken: String?
    var user: User?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        success = data["success"].bool
        sessionToken = data["session_token"].string
        user = User(data: data["user"])
    }
    
}
