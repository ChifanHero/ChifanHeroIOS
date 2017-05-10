//
//  RestaurantTableViewCell.swift
//  SoHungry
//
//  Created by Shi Yan on 8/18/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit
import Kingfisher

class RestaurantTableViewCell: UITableViewCell {
    
    static var height: CGFloat = 100
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(restaurant: Restaurant) {
        nameLabel.text = restaurant.name
        addressLabel.text = restaurant.address
        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: "usingCustomLocation") {
            if restaurant.distance?.value != nil && restaurant.distance?.unit != nil {
                let value = restaurant.distance?.value
                let unit = restaurant.distance?.unit
                distanceLabel.text = String(value!) + " " + unit!
            }
        } else {
            distanceLabel.text = ""
        }
        
        //self.ratingLabel.text = ScoreComputer.getScore(positive: restaurant.likeCount, negative: restaurant.dislikeCount, neutral: restaurant.neutralCount)
        //self.ratingView.backgroundColor = ScoreComputer.getScoreColor(positive: restaurant.likeCount, negative: restaurant.dislikeCount, neutral: restaurant.neutralCount)
        //self.ratingView.layer.cornerRadius = 3
        
        //self.countLabel.text = getTotalRatingCount(positive: restaurant.likeCount, neutral: restaurant.neutralCount, negative: restaurant.dislikeCount)
        
        let url = URL(string: restaurant.picture?.original ?? "")
        restaurantImageView.kf.setImage(with: url, placeholder: UIImage(named: "restaurant_default_background"), options: [.transition(ImageTransition.fade(1))])
        
    }
    
    fileprivate func getTotalRatingCount(positive: Int?, neutral: Int?, negative: Int?) -> String{
        var positive = positive
        var neutral = neutral
        var negative = negative
        
        if (positive == nil) {
            positive = 0
        }
        if (negative == nil) {
            negative = 0
        }
        if (neutral == nil) {
            neutral = 0
        }
        
        return String(positive! + neutral! + negative!)
    }

}
