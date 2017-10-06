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
        passwordTextField.addTarget(self, action: #selector(SignUpTableViewController.didChangeText(_:)), for: .editingChanged)
        configureCheckMarkImage()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TrackingUtil.trackSignupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureCheckMarkImage(){
        self.view.layoutIfNeeded()
        checkmarkImageOne.renderColorChangableImage(UIImage(named: "CheckMark.png")!, fillColor: UIColor.green)
        checkmarkImageOne.isHidden = true
        checkmarkImageTwo.renderColorChangableImage(UIImage(named: "CheckMark.png")!, fillColor: UIColor.green)
        checkmarkImageTwo.isHidden = true
        checkmarkImageThree.renderColorChangableImage(UIImage(named: "CheckMark.png")!, fillColor: UIColor.green)
        checkmarkImageThree.isHidden = true
        checkmarkImageFour.renderColorChangableImage(UIImage(named: "CheckMark.png")!, fillColor: UIColor.green)
        checkmarkImageFour.isHidden = true
    }
    
    fileprivate func configureSignUpButton(){
        signUpButton = LoadingButton(frame: CGRect(x: self.view.frame.width * 0.1, y: 300, width: self.view.frame.width * 0.8, height: 40), color: UIColor.themeOrange(), logoImage: UIImage(named: "LogoWithBorder")!, textContent: "创建用户")
        self.view.addSubview(signUpButton)
        signUpButton.addTarget(self, action: #selector(SignUpTableViewController.createAccountEvent), for: UIControlEvents.touchDown)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func createAccountEvent() {
        let seconds = 2.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            if(self.rule1 && self.rule2 && self.rule3 && self.rule4){
                self.createAccount()
            } else {
                self.signUpButton.stopLoading()
                self.showErrorMessage(title: "注册失败", subTitle: "您的密码过于简单")
            }
        })
    }
    
    private func createAccount() {
        AccountManager(serviceConfiguration: ParseConfiguration()).signUp(username: usernameTextField.text!, password: passwordTextField.text!){(response) -> Void in
            OperationQueue.main.addOperation({ () -> Void in
                self.signUpButton.stopLoading()
                if response == nil {
                    self.showErrorMessage(title: "注册失败", subTitle: "网络错误")
                } else {
                    if response!.success != nil && response!.success! == true {
                        self.loginViewController?.replaceLoginViewByAboutMeView()
                        self.navigationController?.popViewController(animated: true)
                    } else{
                        if let error = response?.error {
                            if error.code == 202 {
                                self.showErrorMessage(title: "注册失败", subTitle: "该用户名已存在")
                            } else if error.code == 125 {
                                self.showErrorMessage(title: "注册失败", subTitle: "请使用邮箱作为用户名")
                            } else {
                                self.showErrorMessage(title: "注册失败", subTitle: "请提供有效用户名和密码")
                            }
                        }
                    }
                }
            })
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            if let username = textField.text {
                if username.characters.count > 0 && username.contains("@") == true{
                    textField.resignFirstResponder()
                    passwordTextField.becomeFirstResponder()
                    return true
                } else {
                    return false
                }
            }
        } else {
            if let password = textField.text {
                if password.characters.count > 0{
                    createAccount()
                    return true
                } else {
                    return false
                }
            }
        }
        return false
    }
    
    private func showErrorMessage(title : String, subTitle : String) {
        AlertUtil.showAlertView(buttonText: "我知道了", infoTitle: title, infoSubTitle: subTitle, target: self, buttonAction: #selector(dismissAlert))
    }
    
    func dismissAlert() {
        
    }
    
    private func resetLogInInput(_ alertAction: UIAlertAction!){
        //currentLoginView?.getAccountTextField()!.text = nil
        //currentLoginView?.getPasswordTextField()!.text = nil
    }
    
    func didChangeText(_ textField:UITextField) {
        validatePassword(textField.text!)
    }
    
    private func validatePassword(_ password: String){
        // rule1: contains uppercase
        // rule2: contains lowercase
        // rule3: contains number
        // rule4: at least 8 characters
        
        do {
            var regex = try NSRegularExpression(pattern: "^(?=.*[A-Z])", options: NSRegularExpression.Options.allowCommentsAndWhitespace)
            var count = regex.numberOfMatches(in: password, options: NSRegularExpression.MatchingOptions.withTransparentBounds, range: NSRange())
            if count > 0 {
                checkmarkImageOne.isHidden = false
                rule1 = true
            } else {
                checkmarkImageOne.isHidden = true
                rule1 = false
            }
            regex = try NSRegularExpression(pattern: "^(?=.*[a-z])", options: NSRegularExpression.Options.allowCommentsAndWhitespace)
            count = regex.numberOfMatches(in: password, options: NSRegularExpression.MatchingOptions.withTransparentBounds, range: NSRange())
            if count > 0 {
                checkmarkImageTwo.isHidden = false
                rule2 = true
            } else {
                checkmarkImageTwo.isHidden = true
                rule2 = false
            }
            regex = try NSRegularExpression(pattern: "^(?=.*[0-9])", options: NSRegularExpression.Options.allowCommentsAndWhitespace)
            count = regex.numberOfMatches(in: password, options: NSRegularExpression.MatchingOptions.withTransparentBounds, range: NSRange())
            if count > 0 {
                checkmarkImageThree.isHidden = false
                rule3 = true
            } else {
                checkmarkImageThree.isHidden = true
                rule3 = false
            }
            regex = try NSRegularExpression(pattern: "^(?=.{8,})", options: NSRegularExpression.Options.allowCommentsAndWhitespace)
            count = regex.numberOfMatches(in: password, options: NSRegularExpression.MatchingOptions.withTransparentBounds, range: NSRange())
            if count > 0 {
                checkmarkImageFour.isHidden = false
                rule4 = true
            } else {
                checkmarkImageFour.isHidden = true
                rule4 = false
            }
        } catch {
            print(error)
        }
        
    }

}
