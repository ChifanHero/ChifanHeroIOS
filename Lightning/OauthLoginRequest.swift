//
//  OauthLoginRequest.swift
//  Lightning
//
//  Created by Zhang, Alex on 6/21/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class OauthLoginRequest: AccountRequest {
    
    var oauthLogin: String?
    
    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        parameters["oauth_login"] = oauthLogin
        return parameters
    }
    
    override func getRelativeURL() -> String {
        return "/users/oauthLogin"
    }
}
