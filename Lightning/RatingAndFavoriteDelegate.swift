//
//  RatingAndFavoriteDelegate.swift
//  Lightning
//
//  Created by Zhang, Alex on 12/9/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

protocol RatingAndFavoriteDelegate {
    
    func like(type: String, objectId: String)
    
    func dislike(type: String, objectId: String)
    
    func neutral(type: String, objectId: String)
    
    func addToFavorites(type: String, objectId: String)
}