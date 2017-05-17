//
//  Restaurant.swift
//  Lightning
//
//  Created by Shi Yan on 8/5/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class Restaurant: Model{
    
    var id: String?
    var name: String?
    var englishName: String?
    var picture: Picture?
    var address: String?
    var city: String?
    var distance: Distance?
    var favoriteCount: Int?
    var phone: String?
    var recommendedDishes: [RecommendedDish] = []
    var rating: Float?
    var ratingCount: Int?
    var reviewInfo: ReviewInfo?
    var photoInfo: PhotoInfo?
    var openNow: Bool?
    var openTimeToday: String?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        id = data["id"].string
        name = data["name"].string
        englishName = data["english_name"].string
        if data["picture"].exists() {
            picture = Picture(data: data["picture"])
        }
        address = data["address"].string
        city = data["city"].string
        if data["distance"].exists() {
            distance = Distance(data: data["distance"])
        }
        favoriteCount = data["favorite_count"].int
        phone = data["phone"].string
        if let resultsJson = data["recommended_dishes"].array {
            for resultJson in resultsJson {
                let result = RecommendedDish(data: resultJson)
                recommendedDishes.append(result)
            }
        }
        rating = data["rating"].float
        ratingCount = data["rating_count"].int
        if data["review_info"].exists() {
            reviewInfo = ReviewInfo(data: data["review_info"])
        }
        if data["photo_info"].exists() {
            photoInfo = PhotoInfo(data: data["photo_info"])
        }
        openNow = data["open_now"].bool
        openTimeToday = data["open_time_today"].string
    }
}
