//
//  GetUserActivitiesRequest.swift
//  Lightning
//
//  Created by Shi Yan on 11/3/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class GetUserActivitiesRequest: HttpRequest{
    
    var limit: Int?
    var skip: Int?
    var userId: String?
    
    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, AnyObject>()
        if limit != nil {
            parameters["limit"] = limit!
        }
        if skip != nil {
            parameters["skip"] = skip!
        }
        if userId != nil {
            parameters["user_id"] = userId
        }
        
        return parameters
    }
    
    override func getRelativeURL() -> String {
        return "/activities"
    }
    
}
