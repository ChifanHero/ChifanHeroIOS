//
//  GetPromotionsResponse.swift
//  Lightning
//
//  Created by Shi Yan on 8/15/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class GetPromotionsResponse: HttpResponseProtocol {
    
    var results: [Promotion] = [Promotion]()
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        error <-- data["error"]
        results = [Promotion]()
        if let resultsJson = data["results"] as? [AnyObject] {
            for resultJson in resultsJson {
                let result = Promotion(data: resultJson as! [String : AnyObject])
                results.append(result)
            }
        }
    }
    
}
