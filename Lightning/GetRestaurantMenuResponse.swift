//  GetRestaurantMenuResponse.swift
//  Lightning
//
//  Created by Shi Yan on 9/8/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class GetRestaurantMenuResponse:  HttpResponseProtocol{
    
    var results: [MenuItem] = [MenuItem]()
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        error <-- data["error"]
        if let resultsJson = data["results"] as? [AnyObject] {
            for resultJson in resultsJson {
                let result = MenuItem(data: resultJson as! [String : AnyObject])
                results.append(result)
            }
        }
    }
}
