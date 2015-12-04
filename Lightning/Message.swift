//
//  Message.swift
//  Lightning
//
//  Created by Shi Yan on 8/16/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class Message: Model {
    
    var id : String?
    var title : String?
    var greeting : String?
    var body : String?
    var signature : String?
    var type : String?
    var read : Bool?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        id <-- data["id"]
        title <-- data["title"]
        greeting <-- data["greeting"]
        body <-- data["body"]
        signature <-- data["signature"]
        type <-- data["type"]
    }
}
