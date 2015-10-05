//
//  LoginRequest.swift
//  SoHungry
//
//  Created by Shi Yan on 10/4/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class LoginRequest: PostRequestProtocol {
    
    var username : String?
    var password : String?
    
    func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        parameters["username"] = username
        parameters["password"] = password
        return parameters
    }
    
    func getRelativeURL() -> String {
        return "/users/signIn"
    }
}
