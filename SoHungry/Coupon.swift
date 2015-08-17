//
//  Coupon.swift
//  SoHungry
//
//  Created by Shi Yan on 8/16/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class Coupon: Model {
    
    var id : String?
    var restaurant : Restaurant?
    var active : Bool?
    var remaining : Int?
    var deadline : NSDate?
    var content : String?
    
    required init(data: [String : AnyObject]) {
        id <-- data["id"]
        restaurant <-- data["restaurant"]
        active <-- data["active"]
        remaining <-- data["remaining"]
        deadline <-- data["deadline"]
        content <-- data["content"]
    }
}
