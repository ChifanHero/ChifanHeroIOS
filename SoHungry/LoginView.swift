//
//  LoginView.swift
//  SoHungry
//
//  Created by Shi Yan on 10/3/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

@IBDesignable class LoginView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var delegate : LoginDelegate?
    
    private var view : UIView!
    private var nibName : String = "LoginView"
    
    
    @IBOutlet weak var accountTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var sinaLoginButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var username : String? {
        get {
            return accountTextField.text
        }
    }
    
    var password : String? {
        get {
            return passwordTextField.text
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
        UISetup()
    }
    
    private func UISetup() {
        signUpButton.layer.cornerRadius = 3
        sinaLoginButton.layer.cornerRadius = 3
        loginButton.layer.cornerRadius = 3
    }
    
    private func LoadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    @IBAction func signUp(sender: AnyObject) {
        delegate?.signUp()
    }
    
    
    @IBAction func loginWithSina(sender: AnyObject) {
        delegate?.logInWithSina()
    }
    
    @IBAction func logIn(sender: AnyObject) {
        delegate?.logIn()
    }
    
    
    

}
