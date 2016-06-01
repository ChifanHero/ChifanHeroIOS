//
//  GetRestaurantCollectionMembersRequest.swift
//  Lightning
//
//  Created by Zhang, Alex on 5/4/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class GetRestaurantCollectionMembersRequest: HttpRequest{
    
    var resourceId: String?
    
    init(id: String){
        self.resourceId = id
    }
    
    override func getRelativeURL() -> String {
        return "/restaurantCollectionMembers/" + resourceId!
    }
}