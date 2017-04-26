//
//  RateAndFavoriteDelegate.swift
//  Lightning
//
//  Created by Shi Yan on 1/17/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

protocol RatingAndBookmarkDelegate {
    
    func failedToRate(objectId : String?, ratingType: RatingTypeEnum)
    
    func failedToBookmark(objectId : String?)
    
}