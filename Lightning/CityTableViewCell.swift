//
//  CityTableViewCell.swift
//  Lightning
//
//  Created by Shi Yan on 5/9/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    var cityName : String? {
        didSet {
            self.cityNameLabel.text = cityName
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
