//
//  InfoCouponTableViewCell.swift
//  SoHungry
//
//  Created by Shi Yan on 9/29/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class InfoCouponTableViewCell: UITableViewCell {

    @IBOutlet weak var tryLuckButton: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tryLuckButton.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
