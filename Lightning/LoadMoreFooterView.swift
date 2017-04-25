//
//  LoadMoreFooterView.swift
//  SoHungry
//
//  Created by Shi Yan on 10/13/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class LoadMoreFooterView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    fileprivate var view : UIView!
    fileprivate var nibName : String = "LoadMoreFooterView"
    
    @IBOutlet weak var finishMessageLabel: UILabel!
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Setup() // Setup when this component is used from Storyboard
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Setup() // Setup when this component is used from Code
    }
    
    func showFinishMessage() {
        self.finishMessageLabel.isHidden = false
    }
    
    func reset() {
        self.activityIndicator.stopAnimating()
        self.finishMessageLabel.isHidden = true
    }
    
    fileprivate func Setup(){
        view = LoadViewFromNib()
        addSubview(view)
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
    }
    
    fileprivate func LoadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

}
