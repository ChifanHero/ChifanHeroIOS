//
//  Picture.swift
//  Lightning
//
//  Created by Shi Yan on 8/16/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class Picture: Model {
    
    var id: String?
    var thumbnail: String?
    var original: String?
    var type: String?
    var restaurant: Restaurant?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        id <-- data["id"]
        thumbnail <-- data["thumbnail"]
        original <-- data["original"]
        type <-- data["type"]
        restaurant <-- data["restaurant"]
    }
    
}
