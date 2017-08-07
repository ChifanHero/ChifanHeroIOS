//
//  RestaurantSearchResponse.swift
//  Lightning
//
//  Created by Shi Yan on 12/5/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON


class RestaurantSearchResponse: HttpResponseProtocol {
    
    var results: [Restaurant] = []
    var error: Error?
    
    required init(data : JSON) {
        error = Error(data: data["error"])
        if let resultsJson = data["results"].array {
            for resultJson in resultsJson {
                let result = Restaurant(data: resultJson)
                results.append(result)
            }
        }
    }
    
    required init() {
        
    }
}
