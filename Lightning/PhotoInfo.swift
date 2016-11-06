//
//  PhotoInfo.swift
//  Lightning
//
//  Created by Shi Yan on 11/6/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class PhotoInfo: Model{
    
    var totalCount: Int?
    var photos: [Picture] = []
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        totalCount <-- data["total_count"]
        if let resultsJson = data["photos"] as? [AnyObject] {
            for resultJson in resultsJson {
                let result = Picture(data: resultJson as! [String : AnyObject])
                photos.append(result)
            }
        }
        
    }
    
    
}
