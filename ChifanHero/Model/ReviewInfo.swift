//
//  ReviewInfo.swift
//  Lightning
//
//  Created by Shi Yan on 11/6/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class ReviewInfo: Model{
    
    var totalCount: Int?
    var reviews: [Review] = []
    
    required init() {
        
    }
    
    required init(data: JSON) {
        totalCount = data["total_count"].int
        if let resultsJson = data["reviews"].array {
            for resultJson in resultsJson {
                let result = Review(data: resultJson)
                reviews.append(result)
            }
        }
        
    }
    
    
}
