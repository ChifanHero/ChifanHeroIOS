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
    
    var id: String!
    var rating: Int!
    var content: String?
    var lastUpdateTime: String?
    var photos: [Picture] = []
    var user: User?
    var restaurant: Restaurant?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        content = data["content"].string
        if data["user"].exists() {
            user = User(data: data["user"])
        }
        lastUpdateTime = data["last_update_time"].string
        rating = data["rating"].int
        if data["restaurant"].exists() {
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
