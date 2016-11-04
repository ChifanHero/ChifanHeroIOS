//
//  GetUserActivitiesResponse.swift
//  Lightning
//
//  Created by Shi Yan on 11/3/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class GetUserActivitiesResponse: HttpResponseProtocol {
    
    var results: [UserActivity] = [UserActivity]()
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        error <-- data["error"]
        if let resultsJson = data["results"] as? [AnyObject] {
            for resultJson in resultsJson {
                let result = UserActivity(data: resultJson as! [String : AnyObject])
                results.append(result)
            }
        }
    }
    
}
