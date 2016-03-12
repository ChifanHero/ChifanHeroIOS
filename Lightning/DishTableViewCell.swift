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
    
//    var model : Model? {
//        didSet {
//            if let dish = model as? Dish {
//                nameLabel.text = dish.name
//                restaurantLabel.text = dish.fromRestaurant?.name
//                scoreLabel.text = String(9.99)
//                if let imageURL = dish.picture?.original {
//                    let url = NSURL(string: imageURL)
//                    let data = NSData(contentsOfURL: url!)
//                    let image = UIImage(data: data!)
//                    dishImageView.image = image
//                }
//            }
//        }
//    }
    
    
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
    
    func setUp(dish dish : Dish) {
        nameLabel.text = dish.name
        restaurantLabel.text = dish.fromRestaurant?.name
        scoreLabel.text = String(9.99)
        var url = ""
        if dish.picture?.thumbnail != nil {
            url = dish.picture!.thumbnail!
        }
        dishImageView.kf_setImageWithURL(NSURL(string: url)!, placeholderImage: UIImage(named: "food placeholder2"),optionsInfo: [.Transition(ImageTransition.Fade(0.5))])
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
