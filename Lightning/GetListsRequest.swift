//
//  GetListsRequest.swift
//  Lightning
//
//  Created by Shi Yan on 8/21/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class GetListsRequest: HttpRequestProtocol {
    
    var limit : Int?
    var skip : Int?
    var userLocation : Location?
    
    func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, AnyObject>()
        if (userLocation != nil) {
            parameters["user_location"] = userLocation?.getProperties()
        }
        if limit != nil {
            parameters["limit"] = limit!
        }
        if skip != nil {
            parameters["skip"] = skip!
        }
        return parameters
    }
        
    func getRelativeURL() -> String {
        return "/lists"
    }
    
}