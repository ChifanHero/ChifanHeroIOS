//
//  PhotoInfo.swift
//  Lightning
//
//  Created by Shi Yan on 11/6/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class PhotoInfo: Model{
    
    var totalCount: Int?
    var photos: [Picture] = []
    
    required init() {
        
    }
    
    required init(data: JSON) {
        totalCount = data["total_count"].int
        if let resultsJson = data["photos"].array {
            for resultJson in resultsJson {
                let result = Picture(data: resultJson)
                photos.append(result)
            }
        }
        
    }
    
    
}
