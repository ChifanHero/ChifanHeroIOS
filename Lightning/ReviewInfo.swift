//
//  ReviewInfo.swift
//  Lightning
//
//  Created by Shi Yan on 11/6/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class ReviewInfo: Model{
    
    var totalCount: Int?
    var reviews: [Review] = []
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        totalCount <-- data["total_count"]
        if let resultsJson = data["reviews"] as? [AnyObject] {
            for resultJson in resultsJson {
                let result = Review(data: resultJson as! [String : AnyObject])
                reviews.append(result)
            }
        }
        
    }
    
    
}
