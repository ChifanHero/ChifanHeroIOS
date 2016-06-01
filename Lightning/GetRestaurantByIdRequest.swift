//
//  GetRestaurantByIdRequest.swift
//  Lightning
//
//  Created by Shi Yan on 8/15/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class GetRestaurantByIdRequest: HttpRequestProtocol{
    
    var resourceId : String
    
    init(id : String) {
        resourceId = id
    }
    
    func getResourceId() -> String {
        return resourceId
    }
    
    func getRelativeURL() -> String {
        return "/restaurants/" + resourceId
    }
    
    func getRequestBody() -> [String : AnyObject] {
        let parameters = Dictionary<String, String>()
        return parameters
    }
    
}