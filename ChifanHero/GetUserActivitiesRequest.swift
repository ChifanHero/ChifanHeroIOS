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
            parameters["limit"] = limit! as AnyObject
        }
        if skip != nil {
            parameters["skip"] = skip! as AnyObject
        }
        if userId != nil {
            parameters["user_id"] = userId as AnyObject
        }
        
        return parameters
    }
    
    override func getRelativeURL() -> String {
        return "/activities"
    }
    
}
