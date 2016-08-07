//
//  RestaurantSearchResponse.swift
//  Lightning
//
//  Created by Shi Yan on 12/5/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation


class RestaurantSearchResponse: HttpResponseProtocol {
    
    var results : [Restaurant] = [Restaurant]()
    var buckets : [Bucket] = [Bucket]()
    var error : Error?
    
    required init(data : [String : AnyObject]) {
        error <-- data["error"]
        if let resultsJson = data["results"] as? [AnyObject] {
            for resultJson in resultsJson {
                let result = Restaurant(data: resultJson as! [String : AnyObject])
                results.append(result)
            }
        }
        if let resultsJson = data["buckets"] as? [AnyObject] {
            for resultJson in resultsJson {
                let result = Bucket(data: resultJson as! [String : AnyObject])
                buckets.append(result)
            }
        }
    }
    
    required init() {
        
    }
}