//
//  RestaurantSearchRequest.swift
//  SoHungry
//
//  Created by Shi Yan on 12/2/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class RestaurantSearchRequest: HttpRequestProtocol{
    
    var keyword : String?
    var offset : Int?
    var limit : Int?
    var sortBy : String?
    var sortOrder : String?
    var parameters : TuningParams?
    var output : Output?
    var userLocation : Location?
    var range : Range?
    var highlightInField : Bool?
    
    func getRequestBody() -> [String : AnyObject] {
        var requestBody = Dictionary<String, AnyObject>()
        requestBody["keyword"] = keyword
        requestBody["offset"] = offset
        requestBody["limit"] = limit
        requestBody["sort_by"] = sortBy
        requestBody["sort_order"] = sortOrder
        requestBody["parameters"] = parameters?.getProperties()
        requestBody["output"] = output?.getProperties()
        requestBody["user_location"] = userLocation?.getProperties()
        requestBody["range"] = range?.getProperties()
        requestBody["highlight_in_field"] = highlightInField
        return requestBody
    }
    
    func getRelativeURL() -> String {
        return "/search/restaurants"
    }
    
    
}
