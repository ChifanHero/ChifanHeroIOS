//
//  ReviewSnapshotTableViewCell.swift
//  Lightning
//
//  Created by Shi Yan on 10/3/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class ReviewSnapshotTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var ratingLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layoutIfNeeded()
        profileImageView.layer.cornerRadius = 4
        ratingLabel.layer.cornerRadius = ratingLabel.frame.size.width / 2
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
