//
//  CommentRestaurantRequest.swift
//  Lightning
//
//  Created by Zhang, Alex on 12/2/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class RateRequest: PostRequestProtocol{
    
    var type: String?
    var action: String?
    var objectId: String?
    
    func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        parameters["type"] = type
        parameters["action"] = action
        parameters["object_id"] = objectId
        return parameters
    }
    
    func getRelativeURL() -> String {
        return "/ratings"
    }
}