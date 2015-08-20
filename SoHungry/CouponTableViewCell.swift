//
//  CouponTableViewCell.swift
//  SoHungry
//
//  Created by Shi Yan on 8/19/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class CouponTableViewCell: UITableViewCell, ModelTableViewCell {
    
    var model : Model? {
        didSet {
            if let coupon = model as? Coupon {
                restaurantLabel.text = coupon.restaurant?.name
                addressLabel.text = coupon.restaurant?.address
            }
        }
    }

    @IBOutlet weak var labelContainer: UIView!
    
    @IBOutlet weak var tryLuckLabelContainer: UIView!
    
    @IBOutlet weak var restaurantLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        labelContainer.layer.borderColor = UIColor.blackColor().CGColor
        labelContainer.layer.borderWidth = 0.4
        labelContainer.backgroundColor = UIColor.clearColor()
        
        tryLuckLabelContainer.layer.borderColor = UIColor.blackColor().CGColor
        tryLuckLabelContainer.layer.borderWidth = 0.4
        tryLuckLabelContainer.backgroundColor = UIColor.clearColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
