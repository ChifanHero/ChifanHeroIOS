//
//  Review.swift
//  Lightning
//
//  Created by Shi Yan on 10/16/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class Review: Model{
    
    var id: String?
    var content: String?
    var user: User?
    var lastUpdateTime: String?
    var rating: String?
    var reviewQuality: Int?
    var goodReview: Bool?
    var pointsRewarded: Int?
    var restaurant: Restaurant?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        content <-- data["content"]
        user <-- data["user"]
        lastUpdateTime <-- data["last_update_time"]
        rating <-- data["rating"]
        reviewQuality <-- data["review_quality"]
        goodReview <-- data["good_review"]
        pointsRewarded <-- data["points_rewarded"]
        restaurant <-- data["restaurant"]
        id <-- data["id"]
        
    }


}
