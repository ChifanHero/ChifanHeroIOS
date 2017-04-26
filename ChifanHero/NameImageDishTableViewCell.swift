//
//  DishTableViewCell.swift
//  SoHungry
//
//  Created by Shi Yan on 8/19/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit
import Kingfisher

class NameImageDishTableViewCell: UITableViewCell {
    
    static var height : CGFloat = 100
    
    @IBOutlet weak var dishImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var rateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        UIsetUp()
        
    }
    
    func UIsetUp() {
        dishImageView.layer.cornerRadius = dishImageView.frame.size.height / 2
        dishImageView.clipsToBounds = true
    }
    
    func setUp(dish : Dish) {
        nameLabel.text = dish.name
        var url = ""
        if dish.picture?.thumbnail != nil {
            url = dish.picture!.thumbnail!
        }
        dishImageView.kf.setImage(with: URL(string: url)!, placeholder: UIImage(named: "food placeholder2"), options: [.transition(ImageTransition.fade(0.5))])
        rateLabel.text = ScoreComputer.getScore(positive: dish.likeCount, negative: dish.dislikeCount, neutral: dish.neutralCount)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
