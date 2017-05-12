//
//  Error.swift
//  Lightning
//
//  Created by Shi Yan on 8/16/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class Error: Model {
    
    var code: Int?
    var message: String?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        code = data["code"].int
        message = data["message"].string
    }
}
