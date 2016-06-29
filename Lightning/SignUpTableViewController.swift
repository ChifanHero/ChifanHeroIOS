//
//  SignUpTableViewController.swift
//  Lightning
//
//  Created by Zhang, Alex on 2/29/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class SignUpTableViewController: UITableViewController, UITextFieldDelegate {

    var loginViewController: LogInTableViewController?
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var checkmarkImageOne: UIImageView!
    @IBOutlet weak var checkmarkImageTwo: UIImageView!
    @IBOutlet weak var checkmarkImageThree: UIImageView!
    @IBOutlet weak var checkmarkImageFour: UIImageView!
    
    // rule1: contains uppercase
    // rule2: contains lowercase
    // rule3: contains number
    // rule4: at least 8 characters
    var rule1 = false
    var rule2 = false
    var rule3 = false
    var rule4 = false
    
    var signUpButton: LoadingButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addImageForBackBarButtonItem()
        self.configureSignUpButton()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpTableViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        passwordTextField.addTarget(self, action: #selector(SignUpTableViewController.didChangeText(_:)), forControlEvents: .EditingChanged)
        configureCheckMarkImage()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        TrackingUtil.trackSignupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureCheckMarkImage(){
        checkmarkImageOne.renderColorChangableImage(UIImage(named: "CheckMark.png")!, fillColor: UIColor.greenColor())
        checkmarkImageOne.hidden = true
        checkmarkImageTwo.renderColorChangableImage(UIImage(named: "CheckMark.png")!, fillColor: UIColor.greenColor())
        checkmarkImageTwo.hidden = true
        checkmarkImageThree.renderColorChangableImage(UIImage(named: "CheckMark.png")!, fillColor: UIColor.greenColor())
        checkmarkImageThree.hidden = true
        checkmarkImageFour.renderColorChangableImage(UIImage(named: "CheckMark.png")!, fillColor: UIColor.greenColor())
        checkmarkImageFour.hidden = true
    }
    
    private func configureSignUpButton(){
        signUpButton = LoadingButton(frame: CGRectMake(self.view.frame.width * 0.1, 300, self.view.frame.width * 0.8, 40), color: UIColor.themeOrange())
        signUpButton.setLogoImage(UIImage(named: "LogoWithBorder")!)
        signUpButton.setTextContent("创建用户")
        self.view.addSubview(signUpButton)
        signUpButton.addTarget(self, action: #selector(SignUpTableViewController.createAccountEvent), forControlEvents: UIControlEvents.TouchDown)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func createAccountEvent() {
        let seconds = 2.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            if(self.rule1 && self.rule2 && self.rule3 && self.rule4){
                self.createAccount()
            } else {
                self.signUpButton.stopLoading()
                self.showErrorMessage("注册失败", message: "您的密码过于简单")
            }
        })
    }
    
    private func createAccount() {
        AccountManager(serviceConfiguration: ParseConfiguration()).signUp(username: usernameTextField.text!, password: passwordTextField.text!){(response) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.signUpButton.stopLoading()
                if response == nil {
                    self.showErrorMessage("注册失败", message: "网络错误")
                } else {
                    if response!.success != nil && response!.success! == true {
                        self.loginViewController?.replaceLoginViewByAboutMeView()
                        self.navigationController?.popViewControllerAnimated(true)
                    } else{
                        if let error = response?.error {
                            if error.code == 202 {
                                self.showErrorMessage("注册失败", message: "用户名已被占用")
                            } else if error.code == 125 {
                                self.showErrorMessage("注册失败", message: "请用邮箱注册")
                            } else {
                                self.showErrorMessage("注册失败", message: "请提供有效用户名和密码")
                            }
                        }
                    }
                }
            })
            
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == usernameTextField {
            let username = textField.text
            if username?.characters.count > 0 && username?.containsString("@") == true{
                textField.resignFirstResponder()
                passwordTextField.becomeFirstResponder()
                return true
            } else {
                return false
            }
        } else {
            let password = textField.text
            if password?.characters.count > 0{
                createAccount()
                return true
            } else {
                return false
            }
        }
    }
    
    private func showErrorMessage(title : String?, message : String?) {
        SCLAlertView().showWarning(title!, subTitle: message!)
    }
    
    private func resetLogInInput(alertAction: UIAlertAction!){
        //currentLoginView?.getAccountTextField()!.text = nil
        //currentLoginView?.getPasswordTextField()!.text = nil
    }
    
    func didChangeText(textField:UITextField) {
        validatePassword(textField.text!)
    }
    
    private func validatePassword(password: String){
        // rule1: contains uppercase
        // rule2: contains lowercase
        // rule3: contains number
        // rule4: at least 8 characters
        
        do {
            var regex = try NSRegularExpression(pattern: "^(?=.*[A-Z])", options: NSRegularExpressionOptions.AllowCommentsAndWhitespace)
            var count = regex.numberOfMatchesInString(password, options: NSMatchingOptions.WithTransparentBounds, range: NSRange())
            if count > 0 {
                checkmarkImageOne.hidden = false
                rule1 = true
            } else {
                checkmarkImageOne.hidden = true
                rule1 = false
            }
            regex = try NSRegularExpression(pattern: "^(?=.*[a-z])", options: NSRegularExpressionOptions.AllowCommentsAndWhitespace)
            count = regex.numberOfMatchesInString(password, options: NSMatchingOptions.WithTransparentBounds, range: NSRange())
            if count > 0 {
                checkmarkImageTwo.hidden = false
                rule2 = true
            } else {
                checkmarkImageTwo.hidden = true
                rule2 = false
            }
            regex = try NSRegularExpression(pattern: "^(?=.*[0-9])", options: NSRegularExpressionOptions.AllowCommentsAndWhitespace)
            count = regex.numberOfMatchesInString(password, options: NSMatchingOptions.WithTransparentBounds, range: NSRange())
            if count > 0 {
                checkmarkImageThree.hidden = false
                rule3 = true
            } else {
                checkmarkImageThree.hidden = true
                rule3 = false
            }
            regex = try NSRegularExpression(pattern: "^(?=.{8,})", options: NSRegularExpressionOptions.AllowCommentsAndWhitespace)
            count = regex.numberOfMatchesInString(password, options: NSMatchingOptions.WithTransparentBounds, range: NSRange())
            if count > 0 {
                checkmarkImageFour.hidden = false
                rule4 = true
            } else {
                checkmarkImageFour.hidden = true
                rule4 = false
            }
        } catch {
            print(error)
        }
        
    }

}
