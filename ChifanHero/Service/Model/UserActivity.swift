//
//  UserActivity.swift
//  Lightning
//
//  Created by Shi Yan on 11/3/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserActivity: Model{
    
    var id: String?
    var lastUpdateTime: String?
    var user: User?
    var type: String?
    var recommendDish: DishRecommendation?
    var review: Review?
    var imageUpload: ImageUploadActivity?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        id = data["id"].string
        user = User(data: data["user"])
        lastUpdateTime = data["last_update_time"].string
        type = data["type"].string
        recommendDish = DishRecommendation(data: data["recommend_dish"])
        review = Review(data: data["review"])
        imageUpload = ImageUploadActivity(data: data["upload_image"])
    }
    
    
}
