//
//  MenuItem.swift
//  SoHungry
//
//  Created by Shi Yan on 9/8/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class MenuItem : Model {
    
    var id : String?
    var name : String?
    var picture : Picture?
    var dishes : [Dish]?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        id <-- data["id"]
        name <-- data["name"]
        picture <-- data["picture"]
        if let resultsJson = data["dishes"] as? [AnyObject] {
            dishes = [Dish]()
            for resultJson in resultsJson {
                let result = Dish(data: resultJson as! [String : AnyObject])
                dishes?.append(result)
            }
        }
    }
    
}
