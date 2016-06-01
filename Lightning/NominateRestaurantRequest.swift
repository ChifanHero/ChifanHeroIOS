//
//  NominateRestaurantRequest.swift
//  Lightning
//
//  Created by Zhang, Alex on 5/24/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class NominateRestaurantRequest: HttpRequestProtocol{
    
    var restaurantId: String?
    var collectionId: String?
    
    func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        parameters["restaurant_id"] = restaurantId
        parameters["collection_id"] = collectionId
        return parameters
    }
    
    func getRelativeURL() -> String {
        return "/restaurantCollectionMemCan"
    }
}