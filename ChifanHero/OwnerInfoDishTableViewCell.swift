//
//  OwnerInfoDishTableViewCell.swift
//  Lightning
//
//  Created by Shi Yan on 1/23/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit
import Kingfisher

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
        self.nameLabel.isHidden = true
        dishImageView.layer.cornerRadius = dishImageView.frame.size.height / 2
        dishImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func gotoRestaurant(_ sender: AnyObject) {
        print("clicked")
        if self.dish != nil {
            baseVC?.performSegue(withIdentifier: "showRestaurant", sender: self.dish?.fromRestaurant?.id)
        }
        
    }
    
    func setUp(dish: Dish, useHTMLRender : Bool) {
        self.dish = dish
        if useHTMLRender && dish.name != nil {
            if dish.name != nil {
                self.nameLabel.attributedText = dish.name!.attributedStringFromHTML(14, highlightColor: UIColor.red)
                self.nameLabel.isHidden = false
            }
            
            
        } else {
            if dish.name == nil {
                self.nameLabel.text = "名称未知"
            } else {
                self.nameLabel.text = dish.name!
            }
            
        }
        self.rateLabel.text = ScoreComputer.getScore(positive: dish.likeCount, negative: dish.dislikeCount, neutral: dish.neutralCount)
        var url = ""
        if dish.picture?.thumbnail != nil {
            url = dish.picture!.thumbnail!
        }
        dishImageView.kf.setImage(with: URL(string: url)!, placeholder: UIImage(named: "food placeholder2"),options: [.transition(ImageTransition.fade(0.5))])
        self.restaurantButton.setTitle(dish.fromRestaurant?.name, for: UIControlState())
        
    }
    
    func setUp(dish: Dish) {
        self.setUp(dish: dish, useHTMLRender: true)
    }
    
    
}
