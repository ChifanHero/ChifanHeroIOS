//
//  RecommendedDish.swift
//  Lightning
//
//  Created by Shi Yan on 8/5/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class RecommendedDish: Model{
    
    var id: String?
    var name: String?
    var recommendationCount: Int?
    var restaurant: Restaurant?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        id = data["id"].string
        name = data["name"].string
        recommendationCount = data["recommendation_count"].int
        if data["restaurant"].exists() {
            restaurant = Restaurant(data: data["restaurant"])
        }
    }
}
