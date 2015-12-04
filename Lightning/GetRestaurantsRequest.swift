//
//  GetRestaurantsRequest.swift
//  SoHungry
//
//  Created by Shi Yan on 8/15/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class GetRestaurantsRequest : GetRequestProtocol{
    
    var limit : Int?
    var offset : Int?
    var sortParameter : SortParameter?
    var sortOrder : SortOrder?
    
    func getParameters() -> [String:String] {
        var parameters = Dictionary<String, String>()
        if limit != nil {
            parameters["limit"] = String(limit!)
        }
        if offset != nil {
            parameters["offset"] = String(offset!)
        }
        if sortParameter != nil && sortOrder != nil{
            parameters["sp"] = sortParameter!.description
            parameters["so"] = sortOrder!.description
        }
        return parameters
    }
    
    func getRelativeURL() -> String {
        return "/restaurants"
    }
    
}