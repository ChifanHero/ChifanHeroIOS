//
//  DishSearchRequest.swift
//  SoHungry
//
//  Created by Shi Yan on 12/2/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class DishSearchRequest : PostRequestProtocol{
    
    var keyword : String?
    var offset : Int?
    var limit : Int?
    var sortBy : String?
    var sortOrder : String?
    var parameters : TuningParams?
    var output : Output?
    var userLocation : Location?
    var restaurantId : String?
    var menuId : String?
    var range : Range?
    
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
        requestBody["restaurant_id"] = restaurantId
        requestBody["menu_id"] = menuId
        requestBody["range"] = range!.getProperties()
        return requestBody
    }
    
    func getRelativeURL() -> String {
        return "/search/dishes"
    }
    
    
}