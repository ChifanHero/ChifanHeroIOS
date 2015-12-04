//
//  GetMessageByIdResponse.swift
//  Lightning
//
//  Created by Shi Yan on 9/3/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class GetMessageByIdResponse : Model {
    
    var result: Message?
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        error <-- data["error"]
        result <-- data["result"]
    }
    
}
