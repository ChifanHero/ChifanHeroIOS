//
//  RestaurantCollectionMemberTableViewCell.swift
//  Lightning
//
//  Created by Zhang, Alex on 5/4/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit
import Kingfisher

class RestaurantCollectionMemberTableViewCell: UITableViewCell {
    
    static var height: CGFloat = 250
    
    var restaurant: Restaurant?
    
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantLocation: UILabel!
    @IBOutlet weak var restaurantRating: UILabel!
    
    
    func setUp(restaurant restaurant: Restaurant) {
        self.restaurant = restaurant
        if restaurant.name != nil {
            self.restaurantName.text = restaurant.name
        }
        
        self.restaurantRating.text = ScoreComputer.getScore(positive: restaurant.likeCount, negative: restaurant.dislikeCount, neutral: restaurant.neutralCount)
        var url: String = ""
        if restaurant.picture?.original != nil {
            url = restaurant.picture!.original!
        }
        restaurantImage.kf_setImageWithURL(NSURL(string: url)!, placeholderImage: UIImage(named: "food placeholder2"),optionsInfo: [.Transition(ImageTransition.Fade(0.5))])
        
    }
}
