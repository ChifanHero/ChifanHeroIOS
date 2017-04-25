//
//  LoginResponse.swift
//  Lightning
//
//  Created by Shi Yan on 10/4/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class LoginResponse: AccountResponse {
    
    required init() {
        super.init()
    }
    
    required init(data: JSON) {
        super.init(data: data)
        self.success = data["success"].bool
        self.sessionToken = data["session_token"].string
        self.user = User(data: data["user"])
    }
}
