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
    
    @IBAction func tryLuck(_ sender: AnyObject) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUp()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp() {
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.borderWidth = 0.4
        containerView.backgroundColor = UIColor.clear
    }

}
