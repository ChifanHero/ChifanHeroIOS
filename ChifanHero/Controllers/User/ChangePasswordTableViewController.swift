//
//  ChangePasswordTableViewController.swift
//  ChifanHero
//
//  Created by Shi Yan on 9/9/17.
//  Copyright © 2017 Lightning. All rights reserved.
//

import UIKit

class ChangePasswordTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var oldPasswordTextField: UITextField!
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    @IBOutlet weak var newPasswordConfirmationTextField: UITextField!
    
    
    @IBOutlet weak var passwordHintsContainer: UIStackView!
    
    var isUsingDefaultPassword: Bool = false
    
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        
        oldPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        newPasswordConfirmationTextField.delegate = self
        passwordHintsContainer.isHidden = true
        
        newPasswordTextField.addTarget(self, action: #selector(ChangePasswordTableViewController.didChangeText(_:)), for: .editingChanged)
        
        let defaultPassword = getDefaultPassword()
        if (isUsingDefaultPassword && defaultPassword != nil) {
            oldPasswordTextField.isUserInteractionEnabled = false
            oldPasswordTextField.text = "您的系统生成密码为: " + defaultPassword! + "。 请尽快修改"
            oldPasswordTextField.isSecureTextEntry = false
        }
        
         configureCheckMarkImage()
        addChangeButton()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == newPasswordTextField {
            passwordHintsContainer.isHidden = false
        } else {
            passwordHintsContainer.isHidden = true
        }
    }
    
    func didChangeText(_ textField:UITextField) {
        validatePassword(textField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == oldPasswordTextField {
            textField.resignFirstResponder()
            newPasswordTextField.becomeFirstResponder()
            return true
        } else if textField == newPasswordTextField {
            if isValidPassword() {
                textField.resignFirstResponder()
                newPasswordConfirmationTextField.becomeFirstResponder()
                return true
            } else {
                return false
            }
        } else if textField == newPasswordConfirmationTextField {
            if isUsingDefaultPassword {
                changePassword(oldPassword: getDefaultPassword(), newPassword: newPasswordTextField.text, newPasswordConfirmation: textField.text)
            } else {
                changePassword(oldPassword: oldPasswordTextField.text, newPassword: newPasswordTextField.text, newPasswordConfirmation: textField.text)
            }
            textField.resignFirstResponder()
            return true
        } else {
            return true
        }
    }
    
    private func getDefaultPassword() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "defaultPassword")
    }
    
    private func isValidPassword() -> Bool {
        return rule1 && rule2 && rule3 && rule4
    }
    
    private func changePassword(oldPassword: String?, newPassword: String?, newPasswordConfirmation: String?) {
        if oldPassword == nil || oldPassword == "" {
            AlertUtil.showAlertView(buttonText: "我知道了", infoTitle: "当前密码不能为空", infoSubTitle: "请提供您的当前密码", target: self, buttonAction: #selector(self.doNothing))
            return
        }
        if !isValidPassword() {
            AlertUtil.showAlertView(buttonText: "我知道了", infoTitle: "新密码未满足安全要求", infoSubTitle: "为保护您的账户安全，新密码至少包含一位大写字母、一位小写字母、一位数字且长度至少8位", target: self, buttonAction: #selector(self.doNothing))
            return
        }
        if newPassword != newPasswordConfirmation {
            AlertUtil.showAlertView(buttonText: "我知道了", infoTitle: "请重新确认密码", infoSubTitle: "您两次输入的密码不同，请重新确认密码", target: self, buttonAction: #selector(self.doNothing))
            return
        }
        AccountManager(serviceConfiguration: ParseConfiguration()).changePassword(oldPassword: oldPassword, newPassword: newPassword) { (response) in
            if response == nil {
                AlertUtil.showGeneralErrorAlert(target: self, buttonAction: #selector(self.doNothing))
            } else if response?.success != nil && response?.success == true {
                AlertUtil.showAlertView(buttonText: "完成", infoTitle: "密码修改成功", infoSubTitle: "", target: self, buttonAction: #selector(self.goBack))
            } else if response?.error?.code != nil {
                AlertUtil.showErrorAlert(errorCode: response?.error?.code, target: self, buttonAction: #selector(self.doNothing))
            } else {
                AlertUtil.showGeneralErrorAlert(target: self, buttonAction: #selector(self.doNothing))
            }
        }
    }
    
    func doNothing() {
        
    }
    
    func goBack() {
        self.navigationController?.popViewController(animated: true)
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
    
    private func addChangeButton() {
        let button: UIButton = ButtonUtil.barButtonWithTextAndBorder("提交", size: CGRect(x: 0, y: 0, width: 80, height: 26))
        button.addTarget(self, action: #selector(ChangePasswordTableViewController.passwordChange(_:)), for: UIControlEvents.touchUpInside)
        let filterButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = filterButton
    }
    
    @IBAction func passwordChange(_ sender: Any) {
        if isUsingDefaultPassword {
            changePassword(oldPassword: getDefaultPassword(), newPassword: newPasswordTextField.text, newPasswordConfirmation: newPasswordConfirmationTextField.text)
        } else {
            changePassword(oldPassword: oldPasswordTextField.text, newPassword: newPasswordTextField.text, newPasswordConfirmation: newPasswordConfirmationTextField.text)
        }
    }

}
