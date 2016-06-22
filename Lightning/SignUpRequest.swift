//
//  SignUpRequest.swift
//  Lightning
//
//  Created by Zhang, Alex on 11/3/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class SignUpRequest: HttpRequest {
    
    var username: String?
    var password: String?
    
    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        parameters["username"] = username
        parameters["password"] = password
        return parameters
    }
    
    override func getRelativeURL() -> String {
        return "/users/signUp"
    }
}