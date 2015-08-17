//
//  Picture.swift
//  SoHungry
//
//  Created by Shi Yan on 8/16/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class Picture : Model {
    
    var thumbnail : String?
    var original : String?
    
    required init(data: [String : AnyObject]) {
        thumbnail <-- data["thumbnail"]
        original <-- data["original"]
    }
    
}
