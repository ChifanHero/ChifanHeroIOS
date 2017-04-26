//
//  DishTableViewCell.swift
//  SoHungry
//
//  Created by Shi Yan on 8/19/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit
import Kingfisher

class DishTableViewCell: UITableViewCell {
    
    static var height : CGFloat = 100
    
    @IBOutlet weak var dishImageView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var restaurantLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.layer.cornerRadius = 5.0
//        self.clipsToBounds = true
        
    }
    
    func setUp(dish : Dish) {
        nameLabel.text = dish.name
        restaurantLabel.text = dish.fromRestaurant?.name
        scoreLabel.text = String(9.99)
        var url = ""
        if dish.picture?.thumbnail != nil {
            url = dish.picture!.thumbnail!
        }
        dishImageView.kf.setImage(with: URL(string: url)!, placeholder: UIImage(named: "food placeholder2"),options: [.transition(ImageTransition.fade(0.5))])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
