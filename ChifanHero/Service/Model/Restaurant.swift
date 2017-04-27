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
    var distance: Distance?
    var favoriteCount: Int?
    var likeCount: Int?
    var dislikeCount: Int?
    var neutralCount: Int?
    var phone: String?
    var hours: String?
    var hotDishes: [Dish] = []
    var votes: Int?
    var dishes: [String]?
    var rating: Double?
    var reviewInfo: ReviewInfo?
    var photoInfo: PhotoInfo?
    
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
        if data["distance"].exists() {
            distance = Distance(data: data["distance"])
        }
        favoriteCount = data["favorite_count"].int
        likeCount = data["like_count"].int
        dislikeCount = data["dislike_count"].int
        neutralCount = data["neutral_count"].int
        phone = data["phone"].string
        hours = data["hours"].string
        if let resultsJson = data["hot_dishes"].array {
            for resultJson in resultsJson {
                let result = Dish(data: resultJson)
                hotDishes.append(result)
            }
        }
        if let resultsJson = data["dishes"].array {
            for resultJson in resultsJson {
                let dish = resultJson.string
                dishes?.append(dish!)
            }
        }
        votes = data["votes"].int
        rating = data["rating"].double
        if data["review_info"].exists() {
            reviewInfo = ReviewInfo(data: data["review_info"])
        }
        if data["photo_info"].exists() {
            photoInfo = PhotoInfo(data: data["photo_info"])
        }
    }
}
