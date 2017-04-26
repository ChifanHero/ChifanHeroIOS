//
//  InfoTableViewCell.swift
//  SoHungry
//
//  Created by Shi Yan on 9/29/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {
    
    var iconResourceName : String? {
        didSet {
            let iconImage = UIImage(named: iconResourceName!)
            icon.image = iconImage
        }
    }
    
    var info : String? {
        didSet {
            infoLabel.text = info
        }
    }

    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
