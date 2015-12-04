//
//  LogOutRequest.swift
//  Lightning
//
//  Created by Zhang, Alex on 11/25/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class LogOutRequest: PostRequestProtocol{
    
    func getRequestBody() -> [String : AnyObject] {
        let parameters = Dictionary<String, String>()
        return parameters
    }
    
    func getRelativeURL() -> String {
        return "/users/logOut"
    }
}