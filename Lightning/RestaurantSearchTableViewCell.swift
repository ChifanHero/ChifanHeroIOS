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
        if restaurant.name != nil {
//            var attributedName = NSAttributedString(
//                data: restaurant.name!.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true),
//                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
//                documentAttributes: nil,
//                error: nil)
            do {
                
                let nameWithSize = NSString(format:"<span style=\"font-size: 15\">%@</span>", restaurant.name!) as String
                let attributedName = try NSMutableAttributedString(data: nameWithSize.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                nameLabel.attributedText = attributedName
            } catch {
                
            }
            
        }
        if restaurant.address != nil {
            do {
                let addressWithSize = NSString(format:"<span style=\"font-size: 12\">%@</span>", restaurant.address!) as String
                let attributedAddress = try NSMutableAttributedString(data: addressWithSize.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                addressLabel.attributedText = attributedAddress
            } catch {
                
            }
        }
        
//        addressLabel.text = restaurant.address
        if restaurant.distance?.value != nil && restaurant.distance?.unit != nil {
            let value = restaurant.distance?.value
            let unit = restaurant.distance?.unit
            distanceLabel.text = String(value!) + " " + unit!
        }
        ratingLabel.text = ScoreComputer.getScore(positive: restaurant.likeCount, negative: restaurant.dislikeCount, neutral: restaurant.neutralCount)
        restaurantImageView.image = image
        var dishNames = ""
        if restaurant.dishes != nil && restaurant.dishes!.count > 0 {
            
            for dish in restaurant.dishes! {
                dishNames += dish
                dishNames += "  "
            }
            dishNames = NSString(format:"<span style=\"font-size: 12\">%@</span>", dishNames) as String
            do {
                let attributedDishNames = try NSMutableAttributedString(data: dishNames.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                dishesLabel.attributedText = attributedDishNames
                dishesLabel.adjustsFontSizeToFitWidth = false
                dishesLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
            } catch {
                
            }
        }
        
        
    }

}
