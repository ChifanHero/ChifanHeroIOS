//
//  GetPromotionsRequest.swift
//  Lightning
//
//  Created by Shi Yan on 8/15/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class GetPromotionsRequest: HttpRequest{
    
    var limit : Int?
    var skip : Int?
    var userLocation : Location?
    
    override func getRelativeURL() -> String {
        return "/promotions"
    }
    
    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, AnyObject>()
        if (userLocation != nil) {
            parameters["user_location"] = userLocation?.getProperties() as AnyObject
        }
        if limit != nil {
            parameters["limit"] = String(limit!) as AnyObject
        }
        if skip != nil {
            parameters["offset"] = String(skip!) as AnyObject
        }
        return parameters
    }
}
