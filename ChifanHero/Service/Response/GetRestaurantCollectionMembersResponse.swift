//
//  GetRestaurantCollectionMembersResponse.swift
//  Lightning
//
//  Created by Zhang, Alex on 5/4/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class GetRestaurantCollectionMembersResponse: HttpResponseProtocol{
    
    var results: [Restaurant] = []
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        if let resultsJson = data["results"].array {
            for resultJson in resultsJson {
                let result = Restaurant(data: resultJson)
                results.append(result)
            }
        }
        error = Error(data: data["error"])
    }
    
}
