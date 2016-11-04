//
//  GetReviewByIdResponse.swift
//  Lightning
//
//  Created by Shi Yan on 11/3/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class GetReviewByIdResponse: HttpResponseProtocol{
    
    var result: Review?
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        error <-- data["error"]
        result <-- data["result"]
    }
    
}
