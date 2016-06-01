//
//  RateResponse.swift
//  Lightning
//
//  Created by Zhang, Alex on 12/4/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class RateResponse: HttpResponseProtocol{
    
    var result: Rating?
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        result <-- data["result"]
        error <-- data["error"]
    }
}