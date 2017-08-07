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
    }
    
    func setUp(restaurant: Restaurant) {
        nameLabel.text = restaurant.name
        addressLabel.text = restaurant.address
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
        if restaurant.picture?.original != nil {
            url = URL(string: restaurant.picture!.original!)
        } else if restaurant.picture?.googlePhotoReference != nil {
            let googlePhotoURL: String = "https://maps.googleapis.com/maps/api/place/photo?key=AIzaSyDbWSwTi-anJJf25HxNrfBNicmrR0JSaOY&maxheight=500&maxwidth=500&photoreference=" + restaurant.picture!.googlePhotoReference!
            url = URL(string: googlePhotoURL)
        } else {
            url = URL(string: "")
        }
        
        restaurantImageView.kf.setImage(with: url, placeholder: UIImage(named: "restaurant_default_background"), options: [.transition(ImageTransition.fade(1))])
    }

}
