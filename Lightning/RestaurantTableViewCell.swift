//
//  RestaurantTableViewCell.swift
//  SoHungry
//
//  Created by Shi Yan on 8/18/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
    
    static var height : CGFloat = 100
    
//    var model : Model? {
//        didSet {
//            if let restaurant = model as? Restaurant {
//                nameLabel.text = restaurant.name
//                addressLabel.text = restaurant.address
//                distanceLabel.text = restaurant.distance
//                if let imageURL = restaurant.picture?.original {
//                    let url = NSURL(string: imageURL)
//                    let data = NSData(contentsOfURL: url!)
//                    let image = UIImage(data: data!)
//                    restaurantImageView.image = image
//                }
//            }
//            
//        }
//    }
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(restaurant restaurant : Restaurant, image : UIImage) {
        nameLabel.text = restaurant.name
        addressLabel.text = restaurant.address
        distanceLabel.text = restaurant.distance
        restaurantImageView.image = image
    }

}
