//
//  NoNetworkDefaultView.swift
//  Lightning
//
//  Created by Shi Yan on 3/6/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class NoNetworkDefaultView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var view: UIView!
    private var nibName: String = "NoNetworkDefaultView"
    
    var parentVC: RefreshableViewController?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBAction func refresh(sender: AnyObject) {
        messageLabel.hidden = true
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        if parentVC != nil {
            parentVC!.loadData({ (success) -> Void in
                if success {
                    self.hide()
                } else {
                    self.show()
                }
            })
          
        }
    }
    
    func show() {
        self.hidden = false
        self.activityIndicator.hidden = true
        self.activityIndicator.stopAnimating()
        self.messageLabel.hidden = false
    }
    
    func hide() {
        self.activityIndicator.stopAnimating()
        self.hidden = true
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        addSubview(view)
        
    }
    
    
    
    func loadViewFromNib() -> UIView{
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }

}
