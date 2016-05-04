//
//  GetRestaurantCollectionMembersResponse.swift
//  Lightning
//
//  Created by Zhang, Alex on 5/4/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class GetRestaurantCollectionMembersResponse: Model{
    
    var results: [Restaurant] = [Restaurant]()
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        if let resultsJson = data["results"] as? [AnyObject] {
            for resultJson in resultsJson {
                let result = Restaurant(data: resultJson as! [String : AnyObject])
                results.append(result)
            }
        }
        error <-- data["error"]
    }
    
}