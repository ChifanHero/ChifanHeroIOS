//
//  LoginView.swift
//  SoHungry
//
//  Created by Shi Yan on 10/10/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit


class LoginView : UIView, UITextFieldDelegate{
    
    var indicator : UIActivityIndicatorView?
    var delegate : LoginDelegate?
    var errorMessage : String? {
        didSet{
            getErrorLabel()?.text = errorMessage
        }
    }
    
    var account : String? {
        get {
            return getAccountTextField()?.text
        }
        set(newValue) {
            getAccountTextField()?.text = newValue
        }
    }
    
    var password : String? {
        get {
            return getPasswordTextField()?.text
        }
        set {
            getPasswordTextField()?.text = newValue
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.restorationIdentifier == "account" {
            let account : String? = textField.text
            if account == nil || account?.characters.count == 0 {
                errorMessage = "请输入账号"
                return false
            } else {
                if isEmailFormat(account!) {
                    getPasswordTextField()?.becomeFirstResponder()
                    return true
                } else {
                    errorMessage = "请用邮箱登录"
                    return false
                }
            }
            
        } else if textField.restorationIdentifier == "password" {
            if textField.text == nil || textField.text?.characters.count == 0 {
                errorMessage = "请输入密码"
                return false
            } else {
                textField.resignFirstResponder()
                startLogin()
            }
            return true
        } else {
            return true
        }
    }

    func isEmailFormat(text : String) -> Bool {
        return text.containsString("@")
    }
    
    func startLogin() {
        if getView() != nil {
            if indicator == nil {
                indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
                indicator!.center = getView()!.center
            }
        }
        delegate?.logIn(account: getAccountTextField()?.text!, password: getPasswordTextField()?.text!)
    }
    
//    func dismissIndicator() {
//        if indicator != nil {
//            indicator?.stopAnimating()
//            indicator?.removeFromSuperview()
//            indicatorActivate = false
//        }
//        
//    }
//    
//    func showIndicator() {
//        if getView() != nil {
//            if indicator == nil {
//                indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
//                indicator!.center = getView()!.center
//            }
//            indicator!.startAnimating()
//            getView()!.addSubview(indicator!)
//            indicatorActivate = true
//        }
//    }
    
    func getErrorLabel() -> UILabel? {
        return nil
    }
    func getView() -> UIView? {
        return nil
    }
    func getPasswordTextField() -> UITextField? {
        return nil
    }
    
    func getAccountTextField() -> UITextField? {
        return nil
    }

}


