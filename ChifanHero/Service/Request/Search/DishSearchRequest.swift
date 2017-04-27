//
//  DishSearchRequest.swift
//  SoHungry
//
//  Created by Shi Yan on 12/2/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class DishSearchRequest: HttpRequest{
    
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
    var highlightInField : Bool?
    
    override func getRequestBody() -> [String : AnyObject] {
        var requestBody = Dictionary<String, AnyObject>()
        requestBody["keyword"] = keyword as AnyObject
        requestBody["offset"] = offset as AnyObject
        requestBody["limit"] = limit as AnyObject
        requestBody["sort_by"] = sortBy as AnyObject
        requestBody["sort_order"] = sortOrder as AnyObject
        requestBody["parameters"] = parameters?.getProperties() as AnyObject
        requestBody["output"] = output?.getProperties() as AnyObject
        requestBody["user_location"] = userLocation?.getProperties() as AnyObject
        requestBody["restaurant_id"] = restaurantId as AnyObject
        requestBody["menu_id"] = menuId as AnyObject
        requestBody["range"] = range?.getProperties() as AnyObject
        requestBody["highlight_in_field"] = highlightInField as AnyObject
        return requestBody
    }
    
    override func getRelativeURL() -> String {
        return "/search/dishes"
    }
    
    
}
