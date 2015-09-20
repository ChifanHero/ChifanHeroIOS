//
//  RestaurantTableViewCell.swift
//  SoHungry
//
//  Created by Shi Yan on 8/18/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell, ModelTableViewCell {
    
    static var height : CGFloat = 109
    
    var model : Model? {
        didSet {
            if let restaurant = model as? Restaurant {
                nameLabel.text = restaurant.name
                addressLabel.text = restaurant.address
                distanceLabel.text = restaurant.distance
                if let imageURL = restaurant.picture?.original {
                    let url = NSURL(string: imageURL)
                    let data = NSData(contentsOfURL: url!)
                    let image = UIImage(data: data!)
                    restaurantImageView.image = image
                }
            }
            
        }
    }
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
        setUp()
    }
    
    func setUp() {
//        restaurantImageView.layer.cornerRadius = 5.0
//        restaurantImageView.clipsToBounds = true
//        layout()
    }
    
//    private func layout() {
//        let leadingConstraintForButton = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: containerViewWidth)
//        let leadingConstraintForImage = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: containerViewWidth)
//        let trailingConstraint = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: containerViewWidth)
//        let horizontalCenterConstraint = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: containerViewWidth)
//        let separatorConstraint = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: containerViewWidth)
//        let separatorConstraint = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: containerViewWidth)
//        
//    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
