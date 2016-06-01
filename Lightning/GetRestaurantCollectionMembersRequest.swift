//
//  GetRestaurantCollectionMembersRequest.swift
//  Lightning
//
//  Created by Zhang, Alex on 5/4/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class GetRestaurantCollectionMembersRequest: HttpRequestProtocol{
    
    var resourceId: String?
    
    init(id: String){
        self.resourceId = id
    }
    
    func getRelativeURL() -> String {
        return "/restaurantCollectionMembers/" + resourceId!
    }
    
    func getRequestBody() -> [String : AnyObject] {
        let parameters = Dictionary<String, String>()
        return parameters
    }
}