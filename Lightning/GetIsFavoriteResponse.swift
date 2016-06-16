//
//  GetIsFavoriteResponse.swift
//  Lightning
//
//  Created by Zhang, Alex on 6/15/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class GetIsFavoriteResponse: HttpResponseProtocol{
    var error: Error?
    var result: Bool?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        error <-- data["error"]
        result <-- data["result"]
    }
}