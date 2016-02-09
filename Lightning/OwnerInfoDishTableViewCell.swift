//
//  OwnerInfoDishTableViewCell.swift
//  Lightning
//
//  Created by Shi Yan on 1/23/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class OwnerInfoDishTableViewCell: UITableViewCell {
    
    var dish : Dish?
    
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
        print("clicked")
        if self.dish != nil {
            baseVC?.performSegueWithIdentifier("showRestaurant", sender: self.dish?.fromRestaurant?.id)
        }
        
    }
    
    func setUp(dish dish: Dish, image: UIImage) {
        self.dish = dish
    
        dispatch_async(dispatch_get_main_queue(), {
            if dish.name != nil {
                do {
                    
                    let nameWithSize = NSString(format:"<span style=\"font-size: 15\">%@</span>", dish.name!) as String
                    let attributedName = try NSMutableAttributedString(data: nameWithSize.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: false)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                    
                    self.nameLabel.attributedText = attributedName
                } catch {
                    
                }
            }
            
            self.rateLabel.text = ScoreComputer.getScore(positive: dish.likeCount, negative: dish.dislikeCount, neutral: dish.neutralCount)
            self.dishImageView.image = image
            
            self.restaurantButton.setTitle(dish.fromRestaurant?.name, forState: UIControlState.Normal)
        });
//        if dish.name != nil {
//            do {
//                
//                let nameWithSize = NSString(format:"<span style=\"font-size: 15\">%@</span>", dish.name!) as String
//                let attributedName = try NSMutableAttributedString(data: nameWithSize.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: false)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
//                
//                nameLabel.attributedText = attributedName
//            } catch {
//                
//            }
//        }
//        
//        rateLabel.text = ScoreComputer.getScore(positive: dish.likeCount, negative: dish.dislikeCount, neutral: dish.neutralCount)
//        dishImageView.image = image
//        
//        restaurantButton.setTitle(dish.fromRestaurant?.name, forState: UIControlState.Normal)
        

    }
    
    
}
