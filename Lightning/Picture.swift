//
//  Picture.swift
//  Lightning
//
//  Created by Shi Yan on 8/16/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class Picture: Model {
    
    var id: String?
    var thumbnail: String?
    var original: String?
    var type: String?
    var restaurant: Restaurant?
    var description: String?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        id = data["id"].string
        thumbnail = data["thumbnail"].string
        original = data["original"].string
        type = data["type"].string
        restaurant = Restaurant(data: data["restaurant"])
        description = data["description"].string
    }
    
}
