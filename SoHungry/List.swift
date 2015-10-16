//
//  List.swift
//  SoHungry
//
//  Created by Shi Yan on 8/5/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class List : Model{
    
    var id : String?
    var name : String?
    var memberCount : Int?
    var dishes : [Dish] = [Dish]()
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        id <-- data["id"]
        name <-- data["name"]
        memberCount <-- data["member_count"]
        if let members = data["dishes"] as? [AnyObject] {
            for dish in members {
                let result = Dish(data: dish as! [String : AnyObject])
                dishes.append(result)
            }
        }
    }
}