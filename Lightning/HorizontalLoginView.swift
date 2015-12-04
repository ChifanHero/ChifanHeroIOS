//
//  HorizontalLoginView.swift
//  SoHungry
//
//  Created by Shi Yan on 10/9/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class HorizontalLoginView: LoginView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    private var view : UIView!
    private var nibName : String = "HorizontalLoginView"
    
    @IBOutlet weak var accountTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var sinaLoginButton: UIButton!
    
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
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
        initTextFields()
    }
    
    private func UISetup() {
        signupButton.layer.cornerRadius = 3
        sinaLoginButton.layer.cornerRadius = 3
        loginButton.layer.cornerRadius = 3
    }
    
    private func initTextFields() {
        accountTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func LoadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    override func getAccountTextField() -> UITextField? {
        return self.accountTextField
    }
    
    override func getPasswordTextField() -> UITextField {
        return self.passwordTextField
    }
    
    override func getView() -> UIView {
        return self.view
    }
    
    override func getErrorLabel() -> UILabel {
        return self.errorLabel
    }
    
    func signIn() {
        //
    }

}
