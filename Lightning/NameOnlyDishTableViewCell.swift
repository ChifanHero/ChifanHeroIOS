//
//  NameOnlyDishTableViewCell.swift
//  Lightning
//
//  Created by Shi Yan on 2/13/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class NameOnlyDishTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(dish: Dish) {
        nameLabel.text = dish.name
    }

}
