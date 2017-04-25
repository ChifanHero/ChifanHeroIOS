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
    fileprivate var nibName: String = "NoNetworkDefaultView"
    
    var parentVC: RefreshableViewDelegate?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBAction func refresh(_ sender: AnyObject) {
        messageLabel.isHidden = true
        activityIndicator.isHidden = false
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
        self.isHidden = false
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
        self.messageLabel.isHidden = false
    }
    
    func hide() {
        self.activityIndicator.stopAnimating()
        self.isHidden = true
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
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
    }
    
    func loadViewFromNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

}
