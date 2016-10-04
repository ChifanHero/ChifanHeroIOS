//
//  EditableReviewTableViewCell.swift
//  Lightning
//
//  Created by Shi Yan on 10/1/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class EditableReviewTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var rateButton1: RateButton!
    
    @IBOutlet weak var rateButton2: RateButton!
    
    @IBOutlet weak var rateButton3: RateButton!
    
    @IBOutlet weak var rateButton4: RateButton!
    
    @IBOutlet weak var rateButton5: RateButton!
    
    @IBOutlet weak var quickReviewView: UIView!
    
    @IBOutlet weak var addDetailReviewButton: UIButton!
    
    var unselectedColor : UIColor?
    
    var rateButtons : [RateButton] = []
    
    var rated = false
    
    var parentViewController : UIViewController?

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
        rateButtons.append(rateButton1)
        rateButtons.append(rateButton2)
        rateButtons.append(rateButton3)
        rateButtons.append(rateButton4)
        rateButtons.append(rateButton5)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func rate1(sender: AnyObject) {
        toggleButton(1)
//        showConfirmView()
    }
    
    @IBAction func rate2(sender: AnyObject) {
        toggleButton(2)
//        showConfirmView()
    }
    
    @IBAction func rate3(sender: AnyObject) {
        toggleButton(3)
//        showConfirmView()
    }
    
    @IBAction func rate4(sender: AnyObject) {
        toggleButton(4)
//        showConfirmView()
    }
    
    
    @IBAction func rate5(sender: AnyObject) {
        toggleButton(5)
//        showConfirmView()
    }
    
    private func toggleButton(id : Int) {
        var button : RateButton?
        if id == 1 {
            button = rateButton1
        } else if id == 2 {
            button = rateButton2
        } else if id == 3 {
            button = rateButton3
        } else if id == 4 {
            button = rateButton4
        } else {
            button = rateButton5
        }
        if rated == true {
            for rateButton in rateButtons {
                rateButton.deselect()
            }
            deleteRate()
            rated = false
        } else {
            for index in 0...(id - 1) {
                rateButtons[index].select()
            }
            rate()
            rated = true
        }
        MILAlertViewManager.sharedInstance.show(.Classic,
                                                text: "MILAlertView Test!",
                                                backgroundColor: UIColor.purpleColor(),
                                                inView: self.parentViewController?.view,
                                                toHeight: 0,
                                                forSeconds:0.5,
                                                callback: nil)
    }
    
    private func deleteRate() {
        
    }
    
    private func rate() {
        
    }
    
    @IBAction func detailReviewViewPressed(sender: AnyObject) {
    }
    
}


