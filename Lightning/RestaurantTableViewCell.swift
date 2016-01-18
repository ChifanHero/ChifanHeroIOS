//
//  RestaurantTableViewCell.swift
//  SoHungry
//
//  Created by Shi Yan on 8/18/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
    
    static var height: CGFloat = 100
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(restaurant restaurant: Restaurant, image: UIImage) {
        nameLabel.text = restaurant.name
        addressLabel.text = restaurant.address
//        addressLabel.adjustsFontSizeToFitWidth = true
//        if let distance = restaurant.distance?.value && unit = restaurant.distance?.unit{
//            distanceLabel.text = String(restaurant.distance?.value!) + " " + unit
//        }
        if restaurant.distance?.value != nil && restaurant.distance?.unit != nil {
            let value = restaurant.distance?.value
            let unit = restaurant.distance?.unit
            distanceLabel.text = String(value!) + " " + unit!
        }
        ratingLabel.text = computePositiveRatingRate(positive: restaurant.likeCount, negative: restaurant.dislikeCount, neutral: restaurant.neutralCount)
        restaurantImageView.image = image
    }
    
    private func computePositiveRatingRate(var positive positive: Int?, var negative: Int?, var neutral: Int?) -> String{
        if (positive == nil) {
            positive = 0
        }
        if (negative == nil) {
            negative = 0
        }
        if (neutral == nil) {
            neutral = 0
        }
        if (positive! + negative! + neutral!) == 0{
            return "尚未评价"
        }
        
        let pos = Double(positive!)
        let neg = Double(negative!)
        let neu = Double(neutral!)
        let result:Double = (pos * 1.0 + neu * 0.7) / (pos + neg + neu) * 100.00
        return String(format:"%.1f", result) + "%"
    }

}
