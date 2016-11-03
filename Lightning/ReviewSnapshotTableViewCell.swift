//
//  ReviewSnapshotTableViewCell.swift
//  Lightning
//
//  Created by Shi Yan on 10/3/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class ReviewSnapshotTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageButton: UIButton!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var levelNameLabel: UILabel!
    
    @IBOutlet weak var reviewTextView: UITextView!
    
    var userName : String? {
        didSet {
            nameLabel.text = userName
        }
    }
    
    var review : String? {
        didSet {
            reviewTextView.text = review
        }
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layoutIfNeeded()
        //profileImageView.layer.cornerRadius = 4
        ratingLabel.layer.cornerRadius = ratingLabel.frame.size.width / 2
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
