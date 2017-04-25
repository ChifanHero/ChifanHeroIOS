//
//  GetRestaurantsRequest.swift
//  Lightning
//
//  Created by Shi Yan on 8/15/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class GetRestaurantsRequest: HttpRequest{
    
    var limit : Int?
    var skip : Int?
    var sortBy : SortParameter?
    var sortOrder : SortOrder?
    var userLocation : Location?
    
    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, AnyObject>()
        if (userLocation != nil) {
            parameters["user_location"] = userLocation?.getProperties() as AnyObject
        }
        if limit != nil {
            parameters["limit"] = limit! as AnyObject
        }
        if skip != nil {
            parameters["skip"] = skip! as AnyObject
        }
        if sortBy != nil && sortOrder != nil{
            parameters["sort_by"] = sortBy!.description as AnyObject
            parameters["sort_order"] = sortOrder?.description as AnyObject
        }
        
        return parameters
    }
    
    override func getRelativeURL() -> String {
        return "/restaurants"
    }
    
}
