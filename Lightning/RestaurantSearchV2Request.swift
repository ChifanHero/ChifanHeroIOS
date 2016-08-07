//
//  RestaurantSearchV2Request.swift
//  Lightning
//
//  Created by Shi Yan on 8/6/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class RestaurantSearchV2Request: HttpRequest{
    
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
    
    override func getRequestBody() -> [String : AnyObject] {
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
    
    override func getRelativeURL() -> String {
        return "/search/v2/restaurants"
    }
    
    
}