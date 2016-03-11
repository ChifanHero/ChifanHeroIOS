//
//  OwnerInfoDishTableViewCell.swift
//  Lightning
//
//  Created by Shi Yan on 1/23/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class OwnerInfoDishTableViewCell: UITableViewCell {
    
    static var height: CGFloat = 100
    
    var dish : Dish?
    
    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var restaurantButton: UIButton!

    @IBOutlet weak var rateLabel: UILabel!
    
    var baseVC : UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.nameLabel.hidden = true
        dishImageView.layer.cornerRadius = dishImageView.frame.size.height / 2
        dishImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func gotoRestaurant(sender: AnyObject) {
        print("clicked")
        if self.dish != nil {
            baseVC?.performSegueWithIdentifier("showRestaurant", sender: self.dish?.fromRestaurant?.id)
        }
        
    }
    
    func setUp(dish dish: Dish, image: UIImage, useHTMLRender : Bool) {
        self.dish = dish
        if useHTMLRender && dish.name != nil {
            if dish.name != nil {
                self.nameLabel.attributedText = dish.name!.attributedStringFromHTML(18, highlightColor: UIColor.redColor())
                self.nameLabel.hidden = false
            }
            
            self.rateLabel.text = ScoreComputer.getScore(positive: dish.likeCount, negative: dish.dislikeCount, neutral: dish.neutralCount)
            self.dishImageView.image = image
            self.restaurantButton.setTitle(dish.fromRestaurant?.name, forState: UIControlState.Normal)
        } else {
            if dish.name == nil {
                self.nameLabel.text = "名称未知"
            } else {
                self.nameLabel.text = dish.name!
            }
            
            self.rateLabel.text = ScoreComputer.getScore(positive: dish.likeCount, negative: dish.dislikeCount, neutral: dish.neutralCount)
            self.dishImageView.image = image
            self.restaurantButton.setTitle(dish.fromRestaurant?.name, forState: UIControlState.Normal)
        }
        
    }
    
    func setUp(dish dish: Dish, image: UIImage) {
        self.setUp(dish: dish, image: image, useHTMLRender: true)
    }
    
    
}
