//
//  GetRestaurantByIdRequest.swift
//  Lightning
//
//  Created by Shi Yan on 8/15/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class GetRestaurantByIdRequest: HttpRequest{
    
    var resourceId: String
    var userLocation: Location?
    
    init(id: String) {
        resourceId = id
    }
    
    func getResourceId() -> String {
        return resourceId
    }
    
    override func getRelativeURL() -> String {
        return "/restaurants/" + resourceId + "?lat=" + String((userLocation?.lat)!) + "&lon=" + String((userLocation?.lon)!)
    }
}
