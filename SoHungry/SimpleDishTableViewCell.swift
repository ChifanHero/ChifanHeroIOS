//
//  SimpleDishTableViewCell.swift
//  SoHungry
//
//  Created by Shi Yan on 9/9/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class SimpleDishTableViewCell: UITableViewCell {
    
    var dishName : String? {
        didSet {
            nameLabel.text = dishName
        }
    }

    @IBOutlet weak var dishImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
