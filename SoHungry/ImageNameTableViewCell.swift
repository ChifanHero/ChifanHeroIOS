//
//  ImageNameTableViewCell.swift
//  SoHungry
//
//  Created by Shi Yan on 8/21/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class ImageNameTableViewCell: UITableViewCell {
    
    var backgroundImageURL : String? {
        didSet {
            if backgroundImageURL != nil {
                let url = NSURL(string: backgroundImageURL!)
                let data = NSData(contentsOfURL: url!)
                let image = UIImage(data: data!)
                backgroundImageView.image = image
            }
            
        }
    }
    
    var name : String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    var englishName : String? {
        didSet {
            englishNameLabel.text = englishName
        }
    }
    
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var englishNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
