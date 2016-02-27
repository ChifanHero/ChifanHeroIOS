//
//  RestaurantSearchTableViewCell.swift
//  Lightning
//
//  Created by Shi Yan on 1/23/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class RestaurantSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var restaurantImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var dishesLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(restaurant restaurant: Restaurant, image: UIImage) {
        dispatch_async(dispatch_get_main_queue(), {
            if restaurant.name != nil {
                do {
                    
                    let nameWithSize = NSString(format:"<span style=\"font-size: 18\">%@</span>", restaurant.name!) as String
                    let attributedName = try NSMutableAttributedString(data: nameWithSize.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                    self.nameLabel.attributedText = attributedName
                } catch {
                    
                }
                
            }
            if restaurant.address != nil {
                do {
                    let addressWithSize = NSString(format:"<span style=\"font-size: 12\">%@</span>", restaurant.address!) as String
                    let attributedAddress = try NSMutableAttributedString(data: addressWithSize.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                    self.addressLabel.attributedText = attributedAddress
                } catch {
                    
                }
            }
            
            //        addressLabel.text = restaurant.address
            if restaurant.distance?.value != nil && restaurant.distance?.unit != nil {
                let value = restaurant.distance?.value
                let unit = restaurant.distance?.unit
                self.distanceLabel.text = String(value!) + " " + unit!
            }
            self.ratingLabel.text = ScoreComputer.getScore(positive: restaurant.likeCount, negative: restaurant.dislikeCount, neutral: restaurant.neutralCount)
            self.restaurantImageView.image = image
            var dishNames = ""
            if restaurant.dishes != nil && restaurant.dishes!.count > 0 {
                
                for dish in restaurant.dishes! {
                    dishNames += dish
                    dishNames += "  "
                }
                dishNames = NSString(format:"<span style=\"font-size: 12\">%@</span>", dishNames) as String
                do {
                    let attributedDishNames = try NSMutableAttributedString(data: dishNames.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                    self.dishesLabel.attributedText = attributedDishNames
                    self.dishesLabel.adjustsFontSizeToFitWidth = false
                    self.dishesLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
                } catch {
                    
                }
            }
        })
        
        
        
    }

}
