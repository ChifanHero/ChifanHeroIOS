//
//  RestaurantNominationCollectionViewCell.swift
//  Lightning
//
//  Created by Zhang, Alex on 5/21/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit
import Kingfisher

class RestaurantNominationCollectionViewCell: UICollectionViewCell {
    
    var restaurant: Restaurant?
    
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantImage: UIImageView!
    
    func setUp(restaurant restaurant: Restaurant) {
        self.restaurant = restaurant
        
        if restaurant.name != nil {
            self.restaurantName.text = restaurant.name
        }
        var url: String = ""
        if restaurant.picture?.original != nil {
            url = restaurant.picture!.original!
        }
        restaurantImage.kf_setImageWithURL(NSURL(string: url)!, placeholderImage: UIImage(named: "restaurant_default_background"),optionsInfo: [.Transition(ImageTransition.Fade(0.5))])
    }
    
    func setUp(){
        self.restaurantName.text = "chi"
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.grayColor().CGColor
    }
    
}
