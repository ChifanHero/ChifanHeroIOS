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
    
    var usingRealLocation : Bool? {
        didSet {
            if usingRealLocation == true {
                self.cityNameLabel.text = "正在使用您的实时位置"
            } else {
                self.cityNameLabel.text = "使用我的实时位置"
            }
            
        }
    }
    
    var activated : Bool? {
        didSet {
            if activated == true {
                cityNameLabel.textColor = UIColor.blackColor()
            } else {
                cityNameLabel.textColor = UIColor.lightGrayColor()
            }
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
