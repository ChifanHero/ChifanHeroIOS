//
//  ReviewDetailTableViewCell.swift
//  ChifanHero
//
//  Created by Shi Yan on 10/30/17.
//  Copyright © 2017 Lightning. All rights reserved.
//

import UIKit

class ReviewDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewDetailTextView: UITextView!
    
    var reviewDetail: String? {
        didSet {
            self.reviewDetailTextView.text = reviewDetail
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reviewDetailTextView.isEditable = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
