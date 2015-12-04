//
//  SignUpView.swift
//  SoHungry
//
//  Created by Zhang, Alex on 11/2/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

@IBDesignable class SignUpView: UIView, UITextFieldDelegate{

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var usernameText : String? {
        get {
            return accountTextField.text
        }
    }
    
    var passwordText : String? {
        get {
            return passwordTextField.text
        }
    }
    
    var delegate : SignUpDelegate?
    
    private var view : UIView!
    private var nibName : String = "SignUpView"
    
    
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
    
    private func LoadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    private func UISetup() {
        confirmButton.layer.cornerRadius = 3
        cancelButton.layer.cornerRadius = 3
    }
    
    private func initTextFields() {
        accountTextField.delegate = self
        passwordTextField.delegate = self
    }

    @IBAction func confirm(sender: AnyObject) {
        delegate?.confirm()
    }
    
    @IBAction func cancel(sender: AnyObject) {
        delegate?.cancel()
    }
    
}
