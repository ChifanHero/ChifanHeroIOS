//
//  GetUserActivitiesResponse.swift
//  Lightning
//
//  Created by Shi Yan on 11/3/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class GetUserActivitiesResponse: HttpResponseProtocol {
    
    var results: [UserActivity] = []
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        error = Error(data: data["error"])
        if let resultsJson = data["results"].array {
            for resultJson in resultsJson {
                let result = UserActivity(data: resultJson)
                results.append(result)
            }
        }
    }
    
}
