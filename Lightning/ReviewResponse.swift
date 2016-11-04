//
//  ReviewResponse.swift
//  Lightning
//
//  Created by Shi Yan on 11/2/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class ReviewResponse: HttpResponseProtocol{
    
    var result: Review?
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        result <-- data["result"]
        error <-- data["error"]
    }
}
