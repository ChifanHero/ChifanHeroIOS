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
    
    func setLogoImage(_ logoImage: UIImage){
        logoView.image = logoImage
    }
    
    func setTextContent(_ text: String){
        labelView.text = text
    }
    
    func initSettingWithColor(_ color:UIColor) {
        self.backgroundView = UIView(frame: self.bounds)
        self.backgroundView.backgroundColor = color
        self.backgroundView.isUserInteractionEnabled = false
        self.backgroundView.layer.cornerRadius = CGFloat(3)
        self.addSubview(self.backgroundView)
        
        defaultW = self.backgroundView.frame.width
        defaultH = self.backgroundView.frame.height
        defaultR = self.backgroundView.layer.cornerRadius
        
        self.spinnerView = MozMaterialDesignSpinner(frame: CGRect(x: 0 , y: 0, width: defaultH*0.8, height: defaultH*0.8))
        self.spinnerView.tintColor = UIColor.white
        self.spinnerView.lineWidth = 2
        self.spinnerView.center = CGPoint(x: self.layer.bounds.midX, y: self.layer.bounds.midY)
        self.spinnerView.translatesAutoresizingMaskIntoConstraints = false
        self.spinnerView.isUserInteractionEnabled = false
        
        self.addSubview(self.spinnerView)
        
        self.logoView = UIImageView(frame: CGRect(x: defaultW*0.2, y: defaultH*0.1, width: defaultH*0.8, height: defaultH*0.8))
        self.logoView.image = UIImage(named: "Wechat")
        self.logoView.contentMode = .scaleAspectFill
        self.logoView.clipsToBounds = true
        self.addSubview(self.logoView)
        
        self.labelView = UILabel(frame: CGRect(x: defaultW*0.5, y: defaultH*0.1, width: 100, height: defaultH*0.8))
        self.labelView.text = "微信登录"
        self.labelView.textColor = UIColor.white
        self.labelView.adjustsFontSizeToFitWidth = true
        self.addSubview(self.labelView)
        
        
        self.addTarget(self, action: #selector(LoadingButton.loadingAction), for: UIControlEvents.touchDown)
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
        self.backgroundView.layer.add(animation, forKey: "cornerRadius")
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            self.backgroundView.layer.bounds = CGRect(x: 0, y: 0, width: self.defaultW*self.scale, height: self.defaultH*self.scale)
        }) { (Bool) -> Void in
            if self.isLoading {
                
                self.logoView.isHidden = true
                self.labelView.isHidden = true
                
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
                    self.backgroundView.layer.bounds = CGRect(x: 0, y: 0, width: self.defaultH*self.scale, height: self.defaultH*self.scale)
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
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
        }) { (Bool) -> Void in
        }
        
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.fromValue = defaultH*scale*0.5
        animation.toValue = defaultR
        animation.duration = 0.3
        self.backgroundView.layer.cornerRadius = defaultR
        self.backgroundView.layer.add(animation, forKey: "cornerRadius")
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            self.backgroundView.layer.bounds = CGRect(x: 0, y: 0, width: self.defaultW*self.scale, height: self.defaultH*self.scale);
        }) { (Bool) -> Void in
            if !self.isLoading {
                
                self.logoView.isHidden = false
                self.labelView.isHidden = false
                
                let animation = CABasicAnimation(keyPath: "cornerRadius")
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
                animation.fromValue = self.backgroundView.layer.cornerRadius
                animation.toValue = self.defaultR
                animation.duration = 0.2
                self.backgroundView.layer.cornerRadius = self.defaultR
                self.backgroundView.layer.add(animation, forKey: "cornerRadius")
                
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
                    self.backgroundView.layer.bounds = CGRect(x: 0, y: 0, width: self.defaultW, height: self.defaultH);
                }) { (Bool) -> Void in
                }
            }
        }
    }
    
}
