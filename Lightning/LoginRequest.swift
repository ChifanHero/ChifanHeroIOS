//
//  LoginRequest.swift
//  Lightning
//
//  Created by Shi Yan on 10/4/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class LoginRequest: AccountRequest {
    
    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        parameters["username"] = username
        parameters["password"] = password
        return parameters
    }
    
    override func getRelativeURL() -> String {
        return "/users/logIn"
    }
}
