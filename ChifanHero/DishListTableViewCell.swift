//
//  DishListTableViewCell.swift
//  Lightning
//
//  Created by Shi Yan on 2/4/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class DishListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
