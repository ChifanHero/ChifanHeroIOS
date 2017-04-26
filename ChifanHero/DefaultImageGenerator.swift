//
//  DefaultImageGenerator.swift
//  Lightning
//
//  Created by Zhang, Alex on 8/4/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class DefaultImageGenerator {
    class func generateRestaurantDefaultImage() -> UIImage {
        let imageArray = ["restaurant_default_background1",
                          "restaurant_default_background2",
                          "restaurant_default_background3",
                          "restaurant_default_background4",
                          "restaurant_default_background5"]
        let randomIndex = Int(arc4random_uniform(5))
        return UIImage(named: imageArray[randomIndex])!
    }
}