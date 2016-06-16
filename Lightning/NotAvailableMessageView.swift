//
//  NotAvailableMessageView.swift
//  Lightning
//
//  Created by Shi Yan on 1/23/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

@IBDesignable class NotAvailableMessageView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    private var view : UIView!
    private var nibName : String = "NotAvailableMessageView"
    
    var restaurantId : String?
    var votes : Int? {
        didSet {
            if votes == nil {
                self.infoLabel.text = "已有 0 位用户申请开通"
            } else {
                self.infoLabel.text = "已有 \(votes!) 位用户申请开通"
            }
            self.infoLabel.hidden = false
        }
    }
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var actionButton: UIButton!
    
    @IBAction func takeAction(sender: AnyObject) {
        var count = 1
        if votes != nil {
            count = votes! + 1
        }
        self.infoLabel.text = "已有 \(count) 位用户申请开通"
        self.actionButton.enabled = false
        if restaurantId != nil {
            let request = VoteRestaurantRequest()
            request.restaurantId = self.restaurantId
            DataAccessor(serviceConfiguration: ParseConfiguration()).voteRestaurant(request, responseHandler: { (response) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    if response == nil {
                        count = count - 1
                        self.infoLabel.text = "已有 \(count) 位用户申请开通"
                    }
//                    let count = response?.result?.votes
//                    if count != nil {
//                        self.infoLabel.text = "已有 \(count!) 位用户申请开通"
//                    }
                    
                });
            })
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Setup() // Setup when this component is used from Storyboard
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Setup() // Setup when this component is used from Code
    }
    
    private func Setup(){
        view = LoadViewFromNib()
        addSubview(view)
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        self.infoLabel.hidden = true
        self.actionButton.enabled = true
    }
    
    private func LoadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }

}
