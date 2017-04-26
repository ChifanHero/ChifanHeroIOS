//
//  SignUpRequest.swift
//  Lightning
//
//  Created by Zhang, Alex on 11/3/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class SignUpRequest: AccountRequest {
    
    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        parameters["username"] = username
        parameters["password"] = password
        return parameters as [String : AnyObject]
    }
    
    override func getRelativeURL() -> String {
        return "/users/signUp"
    }
}
