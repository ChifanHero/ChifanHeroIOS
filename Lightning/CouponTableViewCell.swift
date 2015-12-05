//
//  CouponTableViewCell.swift
//  SoHungry
//
//  Created by Shi Yan on 8/19/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class CouponTableViewCell: UITableViewCell {
    
    static var height : CGFloat = 100
    
    @IBOutlet weak var firstView: UIView!
    
    @IBOutlet weak var secondView: CouponCellSecondView!
    
    @IBOutlet weak var rightPanel: UIView!
    
    
//    var model : Model? {
//        didSet {
//            if let coupon = model as? Coupon {
//                restaurantNameLabel.text = coupon.restaurant?.name
//                restaurantAddressLabel.text = coupon.restaurant?.address
//                restaurantDistanceLabel.text = coupon.restaurant?.distance
//                if let imageURL = coupon.restaurant?.picture?.original {
//                    let url = NSURL(string: imageURL)
//                    let data = NSData(contentsOfURL: url!)
//                    let image = UIImage(data: data!)
//                    restaurantImageView.image = image
//                }
//            }
//        }
//    }

    @IBAction func tryLuck(sender: AnyObject) {
        UIView.transitionWithView(self.rightPanel, duration: 0.6, options: UIViewAnimationOptions.TransitionFlipFromRight, animations: { () -> Void in
            self.rightPanel.insertSubview(self.secondView, aboveSubview: self.firstView)
            }) { (finished) -> Void in
                //
        }
    }
    
    @IBOutlet weak var tryLuckButton: UIButton!
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantAddressLabel: UILabel!
    @IBOutlet weak var restaurantDistanceLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        UIsetUp()
        
    }
    
    func UIsetUp() {
        tryLuckButton.layer.cornerRadius = 4
    }
    
    func setUp(coupon coupon : Coupon, image : UIImage) {
        restaurantNameLabel.text = coupon.restaurant?.name
        restaurantAddressLabel.text = coupon.restaurant?.address
        restaurantDistanceLabel.text = String(coupon.restaurant?.distance?.value)
        restaurantImageView.image = image
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
