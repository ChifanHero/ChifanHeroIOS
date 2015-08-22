//
//  IconDetailCellTableViewCell.swift
//  SoHungry
//
//  Created by Shi Yan on 8/21/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class IconInfoCellTableViewCell: UITableViewCell {
    
    var info : String? {
        didSet {
            infoLabel.text = info
        }
    }
    
    var icon : UIImage? {
        didSet {
            iconView.image = icon
        }
    }

    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var iconView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
