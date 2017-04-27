//
//  Review.swift
//  Lightning
//
//  Created by Shi Yan on 10/16/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class Review: Model{
    
    var id: String?
    var content: String?
    var user: User?
    var lastUpdateTime: String?
    var rating: String?
    var reviewQuality: Int?
    var goodReview: Bool?
    var pointsRewarded: Int?
    var photos: [Picture] = []
    var restaurant: Restaurant?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        content = data["content"].string
        if(data["user"].exists()){
            user = User(data: data["user"])
        }
        lastUpdateTime = data["last_update_time"].string
        rating = data["rating"].string
        reviewQuality = data["review_quality"].int
        goodReview = data["good_review"].bool
        pointsRewarded = data["points_rewarded"].int
        if(data["restaurant"].exists()){
            restaurant = Restaurant(data: data["restaurant"])
        }
        id = data["id"].string
        if let resultsJson = data["photos"].array {
            for resultJson in resultsJson {
                let result = Picture(data: resultJson)
                photos.append(result)
            }
        }
    }


}
