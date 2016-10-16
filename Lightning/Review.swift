//
//  Review.swift
//  Lightning
//
//  Created by Shi Yan on 10/16/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class Review: Model{
    
    var content: String?
    var user: User?
    var date: String?
    var photos: [Picture] = []
    var rating: String?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        content <-- data["content"]
        user <-- data["user"]
        date <-- data["date"]
        if let resultsJson = data["photos"] as? [AnyObject] {
            for resultJson in resultsJson {
                let result = Picture(data: resultJson as! [String : AnyObject])
                photos.append(result)
            }
        }
        rating <-- data["rating"]
    }


}
