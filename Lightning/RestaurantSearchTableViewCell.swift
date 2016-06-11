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
            self.nameLabel.attributedText = restaurant.name!.attributedStringFromHTML(14, highlightColor: LightningColor.themeRed())
        }
        if restaurant.address != nil {
            self.addressLabel.attributedText = restaurant.address?.attributedStringFromHTML(12, highlightColor: LightningColor.themeRed())
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if !defaults.boolForKey("usingCustomLocation") {
            if restaurant.distance?.value != nil && restaurant.distance?.unit != nil {
                let value = restaurant.distance?.value
                let unit = restaurant.distance?.unit
                distanceLabel.text = String(value!) + " " + unit!
            }
        } else {
            distanceLabel.text = ""
        }
        self.ratingLabel.text = ScoreComputer.getScore(positive: restaurant.likeCount, negative: restaurant.dislikeCount, neutral: restaurant.neutralCount)
        var url = ""
        if restaurant.picture?.original != nil {
            url = restaurant.picture!.original!
        }
        restaurantImageView.kf_setImageWithURL(NSURL(string: url)!, placeholderImage: UIImage(named: "restaurant_default_background"), optionsInfo: [.Transition(ImageTransition.Fade(1))])
        var dishNames = ""
        if restaurant.dishes != nil && restaurant.dishes!.count > 0 {
            
            for dish in restaurant.dishes! {
                dishNames += dish
                dishNames += "    "
            }
            self.dishesLabel.attributedText = dishNames.attributedStringFromHTML(12, highlightColor: LightningColor.themeRed())
            self.dishesLabel.adjustsFontSizeToFitWidth = false
            self.dishesLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        } else {
            self.dishesLabel.text = "暂无"
        }
    }

}
