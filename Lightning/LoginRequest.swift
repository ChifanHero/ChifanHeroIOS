//
//  LoginRequest.swift
//  Lightning
//
//  Created by Shi Yan on 10/4/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class LoginRequest: HttpRequestProtocol {
    
    var username : String?
    var password : String?
    
    func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        parameters["username"] = username
        parameters["password"] = password
        return parameters
    }
    
    func getRelativeURL() -> String {
        return "/users/logIn"
    }
}
