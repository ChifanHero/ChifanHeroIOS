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
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUp(restaurant: Restaurant) {
        nameLabel.text = restaurant.name
        addressLabel.text = restaurant.address
        ratingLabel.text = String(describing: restaurant.rating ?? 0)
        ratingLabel.layer.cornerRadius = 4
        ratingLabel.backgroundColor = ScoreComputer.getScoreColor(restaurant.rating ?? 0)
        
        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: USING_NOT_AUTO_DETECTED_LOCATION) {
            if restaurant.distance?.value != nil && restaurant.distance?.unit != nil {
                let value = restaurant.distance?.value
                let unit = restaurant.distance?.unit
                distanceLabel.text = String(value!) + " " + unit!
            }
        } else {
            distanceLabel.text = ""
        }
        
        var url: URL!
        if let original = restaurant.picture?.original {
            url = URL(string: original)
        } else if let googlePhotoReference = restaurant.picture?.googlePhotoReference {
            let googlePhotoURL = UrlUtil.getGooglePhotoReferenceUrl() + googlePhotoReference
            url = URL(string: googlePhotoURL)
        } else {
            url = URL(string: "")
        }
        
        restaurantImageView.kf.setImage(with: url, placeholder: DefaultImageGenerator.generateRestaurantDefaultImage(), options: [.transition(ImageTransition.fade(1))])
    }

}
