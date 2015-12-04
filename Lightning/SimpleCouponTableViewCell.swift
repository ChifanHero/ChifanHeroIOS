//
//  SimpleCouponTableViewCell.swift
//  SoHungry
//
//  Created by Shi Yan on 8/21/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class SimpleCouponTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var containerView: UIView!

    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var tryLuckButton: UIButton!
    
    @IBAction func tryLuck(sender: AnyObject) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUp()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp() {
        containerView.layer.borderColor = UIColor.blackColor().CGColor
        containerView.layer.borderWidth = 0.4
        containerView.backgroundColor = UIColor.clearColor()
    }

}
