//
//  OwnerInfoDishTableViewCell.swift
//  Lightning
//
//  Created by Shi Yan on 1/23/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class OwnerInfoDishTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var restaurantButton: UIButton!

    @IBOutlet weak var rateLabel: UILabel!
    
    var baseVC : UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func gotoRestaurant(sender: AnyObject) {
        baseVC?.performSegueWithIdentifier("showRestaurant", sender: nil)
    }
    
    func setUp(dish dish: Dish, image: UIImage) {
    
        do {
            
            let nameWithSize = NSString(format:"<span style=\"font-size: 15\">%@</span>", dish.name!) as String
            let attributedName = try NSMutableAttributedString(data: nameWithSize.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            nameLabel.attributedText = attributedName
        } catch {
            
        }
        rateLabel.text = ScoreComputer.getScore(positive: dish.likeCount, negative: dish.dislikeCount, neutral: dish.neutralCount)
        dishImageView.image = image
        
//        do {
//            
//            let restaurantName = NSString(format:"<span style=\"font-size: 12\">%@</span>", (dish.fromRestaurant?.name)!) as String
////            let restaurantName = NSString(format:"<span style=\"font-size: 12\">%@</span>", "<b>测试</b>餐厅") as String
//            let attributedRestaurantName = try NSMutableAttributedString(data: restaurantName.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
////            restaurantButton.titleLabel?.attributedText = attributedRestaurantName
//            restaurantButton.setAttributedTitle(attributedRestaurantName, forState: UIControlState.Normal)
//        } catch {
//            
//        }
        restaurantButton.setTitle(dish.fromRestaurant?.name, forState: UIControlState.Normal)
        

    }
    
    
}
