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
    var review: Review?
    var googlePhotoReference: String?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        id = data["id"].string
        thumbnail = data["thumbnail"].string
        original = data["original"].string
        type = data["type"].string
        if data["restaurant"].exists() {
            restaurant = Restaurant(data: data["restaurant"])
        }
        if data["review"].exists() {
            review = Review(data: data["review"])
        }
        googlePhotoReference = data["google_photo_reference"].string
    }
    
}
