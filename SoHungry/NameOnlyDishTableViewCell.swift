//
//  DishTableViewCell.swift
//  SoHungry
//
//  Created by Shi Yan on 8/19/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class NameOnlyDishTableViewCell: UITableViewCell, ModelTableViewCell {
    
    static var height : CGFloat = 150
    
    var model : Model? {
        didSet {
            if let dish = model as? Dish {
                nameLabel.text = dish.name
                if let imageURL = dish.picture?.original {
                    let url = NSURL(string: imageURL)
                    let data = NSData(contentsOfURL: url!)
                    let image = UIImage(data: data!)
                    dishImageView.image = image
                }
            }
        }
    }
    
    
    @IBOutlet weak var dishImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUp()
        
    }
    
    func setUp() {
        dishImageView.layer.cornerRadius = dishImageView.frame.size.height / 2
        dishImageView.clipsToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
