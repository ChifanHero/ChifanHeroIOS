//
//  CouponTableViewCell.swift
//  SoHungry
//
//  Created by Shi Yan on 8/19/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class CouponTableViewCell: UITableViewCell, ModelTableViewCell {
    
    static var height : CGFloat = 100
    
    var model : Model? {
        didSet {
            if let coupon = model as? Coupon {
                restaurantNameLabel.text = coupon.restaurant?.name
                restaurantAddressLabel.text = coupon.restaurant?.address
                restaurantDistanceLabel.text = coupon.restaurant?.distance
                if let imageURL = coupon.restaurant?.picture?.original {
                    let url = NSURL(string: imageURL)
                    let data = NSData(contentsOfURL: url!)
                    let image = UIImage(data: data!)
                    restaurantImageView.image = image
                }
            }
        }
    }

    @IBAction func tryLuck(sender: AnyObject) {
        
    }
    
    @IBOutlet weak var tryLuckButton: UIButton!
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantAddressLabel: UILabel!
    @IBOutlet weak var restaurantDistanceLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUp()
        
    }
    
    func setUp() {
        tryLuckButton.layer.cornerRadius = 4
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
