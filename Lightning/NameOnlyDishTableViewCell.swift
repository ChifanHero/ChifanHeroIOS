//
//  DishTableViewCell.swift
//  SoHungry
//
//  Created by Shi Yan on 8/19/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class NameOnlyDishTableViewCell: UITableViewCell {
    
    static var height : CGFloat = 82
    
    @IBOutlet weak var dishImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        UIsetUp()
        
    }
    
    func UIsetUp() {
        dishImageView.layer.cornerRadius = dishImageView.frame.size.height / 2
        dishImageView.clipsToBounds = true
    }
    
    func setUp(dish dish : Dish, image : UIImage) {
        nameLabel.text = dish.name
        dishImageView.image = image
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
