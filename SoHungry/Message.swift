//
//  Message.swift
//  SoHungry
//
//  Created by Shi Yan on 8/16/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class Message: Model {
    
    var id : String?
    var title : String?
    var greeting : String?
    var body : String?
    var signature : String?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        id <-- data["id"]
        title <-- data["title"]
        greeting <-- data["greeting"]
        body <-- data["body"]
        signature <-- data["signature"]
    }
}
