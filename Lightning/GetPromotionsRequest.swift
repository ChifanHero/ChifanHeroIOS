//
//  GetPromotionsRequest.swift
//  Lightning
//
//  Created by Shi Yan on 8/15/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class GetPromotionsRequest : PostRequestProtocol{
    
    var limit : Int?
    var offset : Int?
    var userLocation : Location?
    
    func getRelativeURL() -> String {
        return "/promotions"
    }
    
    func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, AnyObject>()
        if (userLocation != nil) {
            parameters["user_location"] = userLocation?.getProperties()
        }
        if limit != nil {
            parameters["limit"] = String(limit!)
        }
        if offset != nil {
            parameters["offset"] = String(offset!)
        }
        return parameters
    }
}
