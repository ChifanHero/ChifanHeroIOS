//
//  LoadingButton.swift
//  Lightning
//
//  Created by Zhang, Alex on 6/17/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class LoadingButton: UIButton {
    
    var defaultW: CGFloat!
    var defaultH: CGFloat!
    var defaultR: CGFloat!
    
    var scale: CGFloat = 1.2
    var backgroundView: UIView!
    var logoView: UIImageView!
    var labelView: UILabel!
    
    var spinnerView: MozMaterialDesignSpinner!
    
    var isLoading: Bool = false
    
    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        initSettingWithColor(color)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSettingWithColor(self.tintColor)
    }
    
    func setLogoImage(logoImage: UIImage){
        logoView.image = logoImage
    }
    
    func setTextContent(text: String){
        labelView.text = text
    }
    
    func initSettingWithColor(color:UIColor) {
        self.backgroundView = UIView(frame: self.bounds)
        self.backgroundView.backgroundColor = color
        self.backgroundView.userInteractionEnabled = false
        self.backgroundView.layer.cornerRadius = CGFloat(3)
        self.addSubview(self.backgroundView)
        
        defaultW = self.backgroundView.frame.width
        defaultH = self.backgroundView.frame.height
        defaultR = self.backgroundView.layer.cornerRadius
        
        self.spinnerView = MozMaterialDesignSpinner(frame: CGRectMake(0 , 0, defaultH*0.8, defaultH*0.8))
        self.spinnerView.tintColor = UIColor.whiteColor()
        self.spinnerView.lineWidth = 2
        self.spinnerView.center = CGPointMake(CGRectGetMidX(self.layer.bounds), CGRectGetMidY(self.layer.bounds))
        self.spinnerView.translatesAutoresizingMaskIntoConstraints = false
        self.spinnerView.userInteractionEnabled = false
        
        self.addSubview(self.spinnerView)
        
        self.logoView = UIImageView(frame: CGRectMake(defaultW*0.2, defaultH*0.1, defaultH*0.8, defaultH*0.8))
        self.logoView.image = UIImage(named: "Wechat")
        self.logoView.contentMode = .ScaleAspectFill
        self.logoView.clipsToBounds = true
        self.addSubview(self.logoView)
        
        self.labelView = UILabel(frame: CGRectMake(defaultW*0.5, defaultH*0.1, 100, defaultH*0.8))
        self.labelView.text = "微信登录"
        self.labelView.textColor = UIColor.whiteColor()
        self.labelView.adjustsFontSizeToFitWidth = true
        self.addSubview(self.labelView)
        
        
        self.addTarget(self, action: #selector(LoadingButton.loadingAction), forControlEvents: UIControlEvents.TouchDown)
    }
    
    func loadingAction() {
        if (self.isLoading) {
            self.stopLoading()
        }else{
            self.startLoading()
        }
    }
    
    func startLoading(){
        
        isLoading = true
        
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.fromValue = defaultR
        animation.toValue = defaultH*scale*0.5
        animation.duration = 0.3
        self.backgroundView.layer.cornerRadius = defaultH*scale*0.5
        self.backgroundView.layer.addAnimation(animation, forKey: "cornerRadius")
        
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.backgroundView.layer.bounds = CGRectMake(0, 0, self.defaultW*self.scale, self.defaultH*self.scale)
        }) { (Bool) -> Void in
            if self.isLoading {
                
                self.logoView.hidden = true
                self.labelView.hidden = true
                
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    self.backgroundView.layer.bounds = CGRectMake(0, 0, self.defaultH*self.scale, self.defaultH*self.scale)
                }) { (Bool) -> Void in
                    if self.isLoading {
                        self.spinnerView.startAnimating()
                    }
                }
                
            }
        }
    }
    
    func stopLoading(){
        isLoading = false;
        self.spinnerView.stopAnimating()
        
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
        }) { (Bool) -> Void in
        }
        
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.fromValue = defaultH*scale*0.5
        animation.toValue = defaultR
        animation.duration = 0.3
        self.backgroundView.layer.cornerRadius = defaultR
        self.backgroundView.layer.addAnimation(animation, forKey: "cornerRadius")
        
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.backgroundView.layer.bounds = CGRectMake(0, 0, self.defaultW*self.scale, self.defaultH*self.scale);
        }) { (Bool) -> Void in
            if !self.isLoading {
                
                self.logoView.hidden = false
                self.labelView.hidden = false
                
                let animation = CABasicAnimation(keyPath: "cornerRadius")
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
                animation.fromValue = self.backgroundView.layer.cornerRadius
                animation.toValue = self.defaultR
                animation.duration = 0.2
                self.backgroundView.layer.cornerRadius = self.defaultR
                self.backgroundView.layer.addAnimation(animation, forKey: "cornerRadius")
                
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    self.backgroundView.layer.bounds = CGRectMake(0, 0, self.defaultW, self.defaultH);
                }) { (Bool) -> Void in
                }
            }
        }
    }
    
}