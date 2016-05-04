//
//  GetRestaurantCollectionMembersRequest.swift
//  Lightning
//
//  Created by Zhang, Alex on 5/4/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class GetRestaurantCollectionMembersRequest: GetRequestProtocol{
    
    var resourceId: String?
    
    init(id: String){
        self.resourceId = id
    }
    
    func getRelativeURL() -> String {
        return "/restaurantCollectionMembers/" + resourceId!
    }
}