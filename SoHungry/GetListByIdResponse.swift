//
//  GetListByIdResponse.swift
//  SoHungry
//
//  Created by Shi Yan on 10/15/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class GetListByIdResponse: Model {
    
    var result : List?
    var error : Error?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        error <-- data["error"]
        result <-- data["result"]
    }
    
}
