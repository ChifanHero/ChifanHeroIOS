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
            parameters["user_location"] = userLocation?.getProperties()
        }
        if limit != nil {
            parameters["limit"] = limit!
        }
        if skip != nil {
            parameters["skip"] = skip!
        }
        if sortBy != nil && sortOrder != nil{
            parameters["sort_by"] = sortBy!.description
            parameters["sort_order"] = sortOrder?.description
        }
        
        return parameters
    }
    
    override func getRelativeURL() -> String {
        return "/restaurants"
    }
    
}