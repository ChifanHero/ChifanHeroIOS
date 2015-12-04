//
//  GetPromotionsRequest.swift
//  SoHungry
//
//  Created by Shi Yan on 8/15/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class GetPromotionsRequest : GetRequestProtocol{
    
    var limit : Int?
    var offset : Int?
    
    func getParameters() -> [String:String] {
        var parameters = Dictionary<String, String>()
        if limit != nil {
            parameters["limit"] = String(limit!)
        }
        if offset != nil {
            parameters["offset"] = String(offset!)
        }
        return parameters
    }
    
    func getRelativeURL() -> String {
        return "/promotions"
    }
}
