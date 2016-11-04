//
//  GetReviewsResponse.swift
//  Lightning
//
//  Created by Shi Yan on 11/2/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class GetReviewsResponse: HttpResponseProtocol {
    
    var results: [Review] = [Review]()
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        error <-- data["error"]
        if let resultsJson = data["results"] as? [AnyObject] {
            for resultJson in resultsJson {
                let result = Review(data: resultJson as! [String : AnyObject])
                results.append(result)
            }
        }
    }
    
}
