//
//  EditableReviewTableViewCell.swift
//  Lightning
//
//  Created by Shi Yan on 10/1/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class EditableReviewTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var rateButton1: UIButton!
    
    @IBOutlet weak var rateButton2: UIButton!
    
    @IBOutlet weak var rateButton3: UIButton!
    
    @IBOutlet weak var rateButton4: UIButton!
    
    @IBOutlet weak var rateButton5: UIButton!
    
    @IBOutlet weak var quickReviewView: UIView!
    
    @IBOutlet weak var addDetailReviewButton: UIButton!
    
    var unselectedColor : UIColor?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layoutIfNeeded()
        rateButton1.layer.cornerRadius = rateButton1.frame.size.width / 2
        rateButton2.layer.cornerRadius = rateButton2.frame.size.width / 2
        rateButton3.layer.cornerRadius = rateButton3.frame.size.width / 2
        rateButton4.layer.cornerRadius = rateButton4.frame.size.width / 2
        rateButton5.layer.cornerRadius = rateButton5.frame.size.width / 2
        addDetailReviewButton.layer.cornerRadius = 4
        unselectedColor = rateButton1.backgroundColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func rate1(sender: AnyObject) {
        toggleRateButton(1, selected: true)
//        showConfirmView()
    }
    
    @IBAction func rate2(sender: AnyObject) {
        toggleRateButton(1, selected: true)
        toggleRateButton(2, selected: true)
//        showConfirmView()
    }
    
    @IBAction func rate3(sender: AnyObject) {
        toggleRateButton(1, selected: true)
        toggleRateButton(2, selected: true)
        toggleRateButton(3, selected: true)
//        showConfirmView()
    }
    
    @IBAction func rate4(sender: AnyObject) {
        toggleRateButton(1, selected: true)
        toggleRateButton(2, selected: true)
        toggleRateButton(3, selected: true)
        toggleRateButton(4, selected: true)
//        showConfirmView()
    }
    
    private func toggleRateButton(rate : Int, selected : Bool) {
        var color = UIColor.redColor()
        var button : UIButton?
        
        if rate == 1 {
            button = rateButton1
        } else if rate == 2 {
            button = rateButton2
        } else if rate == 3 {
            button = rateButton3
        } else if rate == 4 {
            button = rateButton4
        } else {
            button = rateButton5
        }
        if selected == false {
            color = unselectedColor!
        }
        UIView.animateWithDuration(0.2, animations: {
            button?.alpha = 0
            }) { (done) in
                button?.backgroundColor = color
                UIView.animateWithDuration(0.2, delay: 0.5, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                    button?.alpha = 1
                    }, completion: nil)
        }
        
    }
    
    @IBAction func rate5(sender: AnyObject) {
        toggleRateButton(1, selected: true)
        toggleRateButton(2, selected: true)
        toggleRateButton(3, selected: true)
        toggleRateButton(4, selected: true)
        toggleRateButton(5, selected: true)
//        showConfirmView()
    }
    
    @IBAction func detailReviewViewPressed(sender: AnyObject) {
    }
    
}
