//
//  RestaurantSearchTableViewCell.swift
//  Lightning
//
//  Created by Shi Yan on 1/23/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class RestaurantSearchTableViewCell: UITableViewCell {
    
    static var height: CGFloat = 120

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
//        dispatch_async(dispatch_get_main_queue(), {
//           
//        })
        if restaurant.name != nil {
            //                do {
            //                    let colordName = self.addColorToString(restaurant.name!)
            //                    let nameWithSize = NSString(format:"<span style=\"font-size: 14\">%@</span>", colordName) as String
            //                    let attributedName = try NSMutableAttributedString(data: nameWithSize.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            //                    self.nameLabel.attributedText = attributedName
            //                } catch {
            //
            //                }
            self.nameLabel.attributedText = restaurant.name!.attributedStringFromHTML(14, highlightColor: UIColor.redColor())
//            self.nameLabel.text = restaurant.name!
            
        }
        if restaurant.address != nil {
            //                do {
            //                    let colordName = self.addColorToString(restaurant.address!)
            //                    let nameWithSize = NSString(format:"<span style=\"font-size: 12\">%@</span>", colordName) as String
            //                    let attributedName = try NSMutableAttributedString(data: nameWithSize.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            //                    self.addressLabel.attributedText = attributedName
            //                } catch {
            //
            //                }
            self.addressLabel.attributedText = restaurant.address?.attributedStringFromHTML(12, highlightColor: UIColor.redColor())
//            self.addressLabel.text = restaurant.address!
        }
        
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
                //                    dishNames += self.addColorToString(dish)
                dishNames += dish
                //                    dishNames += "&nbsp&nbsp&nbsp&nbsp"
                dishNames += "  "
            }
            //                dishNames = NSString(format:"<span style=\"font-size: 12\">%@</span>", dishNames) as String
            //                do {
            //                    let attributedDishNames = try NSMutableAttributedString(data: dishNames.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            //                    self.dishesLabel.attributedText = attributedDishNames
            //                    self.dishesLabel.adjustsFontSizeToFitWidth = false
            //                    self.dishesLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
            //                } catch {
            //
            //                }
            self.dishesLabel.attributedText = dishNames.attributedStringFromHTML(12, highlightColor: UIColor.redColor())
//            self.dishesLabel.text = dishNames
            self.dishesLabel.adjustsFontSizeToFitWidth = false
            self.dishesLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        } else {
            self.dishesLabel.text = "暂无"
        }
    }
    
//    private func addColorToString(originalString: String) -> String {
//        var result: String?
//        
//        result = originalString.stringByReplacingOccurrencesOfString("<b>", withString:"<b><font color=\"red\">")
//        
//        result = result!.stringByReplacingOccurrencesOfString("</b>", withString:"</font></b>")
//        
//        return result!
//    }

}
