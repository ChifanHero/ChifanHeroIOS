//
//  RestaurantSearchTableViewCell.swift
//  Lightning
//
//  Created by Shi Yan on 1/23/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit
import Kingfisher

class RestaurantSearchTableViewCell: UITableViewCell {
    
    static var height: CGFloat = 120

    @IBOutlet weak var restaurantImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var dishesLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(restaurant restaurant: Restaurant) {

        if restaurant.name != nil {
            self.nameLabel.attributedText = restaurant.name!.attributedStringFromHTML(14, highlightColor: UIColor.redColor())
        }
        if restaurant.address != nil {
            self.addressLabel.attributedText = restaurant.address?.attributedStringFromHTML(12, highlightColor: UIColor.redColor())
        }
        
        if restaurant.distance?.value != nil && restaurant.distance?.unit != nil {
            let value = restaurant.distance?.value
            let unit = restaurant.distance?.unit
            self.distanceLabel.text = String(value!) + " " + unit!
        }
        self.ratingLabel.text = ScoreComputer.getScore(positive: restaurant.likeCount, negative: restaurant.dislikeCount, neutral: restaurant.neutralCount)
        var url = ""
        if restaurant.picture?.thumbnail != nil {
            url = restaurant.picture!.thumbnail!
        }
        restaurantImageView.kf_setImageWithURL(NSURL(string: url)!, placeholderImage: UIImage(named: "food placeholder2"), optionsInfo: [.Transition(ImageTransition.Fade(0.5))])
        var dishNames = ""
        if restaurant.dishes != nil && restaurant.dishes!.count > 0 {
            
            for dish in restaurant.dishes! {
                dishNames += dish
                dishNames += "  "
            }
            self.dishesLabel.attributedText = dishNames.attributedStringFromHTML(12, highlightColor: UIColor.redColor())
            self.dishesLabel.adjustsFontSizeToFitWidth = false
            self.dishesLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        } else {
            self.dishesLabel.text = "暂无"
        }
    }

}
