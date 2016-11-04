//
//  UserActivity.swift
//  Lightning
//
//  Created by Shi Yan on 11/3/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

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
    
    required init(data: [String : AnyObject]) {
        id <-- data["id"]
        user <-- data["user"]
        lastUpdateTime <-- data["last_update_time"]
        type <-- data["type"]
        recommendDish <-- data["recommend_dish"]
        review <-- data["review"]
        imageUpload <-- data["upload_image"]
        
    }
    
    
}
