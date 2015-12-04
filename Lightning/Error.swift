//
//  Error.swift
//  SoHungry
//
//  Created by Shi Yan on 8/16/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class Error : Model {
    
    var code : Int?
    var message : String?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        code <-- data["code"]
        message <-- data["message"]
    }
}
