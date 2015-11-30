//
//  Picture.swift
//  SoHungry
//
//  Created by Shi Yan on 8/16/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class Picture : Model {
    
    var id: String?
    var thumbnail: String?
    var original: String?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        id <-- data["id"]
        thumbnail <-- data["thumbnail"]
        original <-- data["original"]
    }
    
}
