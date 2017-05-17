//
//  PutRequest.swift
//  Lightning
//
//  Created by Zhang, Alex on 5/24/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class NominateRestaurantRequest: HttpRequest{
    
    var restaurantId: String?
    var collectionId: String?
    
    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        parameters["restaurant_id"] = restaurantId
        parameters["collection_id"] = collectionId
        return parameters as [String : AnyObject]
    }
    
    override func getRelativeURL() -> String {
        return "/restaurantCollectionMemCan"
    }
}

class UpdateRestaurantInfoRequest: HttpRequest{

    var restaurantId: String?
    var imageId: String?

    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        parameters["image_id"] = imageId
        return parameters as [String : AnyObject]
    }

    override func getRelativeURL() -> String {
        return "/restaurants/" + restaurantId!
    }
}
