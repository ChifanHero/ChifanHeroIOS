//
//  ForgotPasswordTableViewController.swift
//  ChifanHero
//
//  Created by Shi Yan on 9/8/17.
//  Copyright © 2017 Lightning. All rights reserved.
//

import UIKit

class ForgotPasswordTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    
    var sendButton: RetryButton?
    
    var isResettingPassword = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        emailTextField.delegate = self
        self.configureButton()
        emailTextField.addTarget(self, action: #selector(ForgotPasswordTableViewController.didChangeText(_:)), for: .editingChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func configureButton() {
        sendButton = RetryButton(frame: CGRect(x: self.view.frame.width * 0.1, y: 100, width: self.view.frame.width * 0.8, height: 40))
        sendButton!.setCountdown(enabled: true, seconds: 10)
        sendButton!.setNormalState(text: "发送", color: nil, size: nil, backgroundColor: nil)
        sendButton!.setWaitingState(text: "已发送。如未收到邮件请重新发送", color: nil, size: nil, backgroundColor: nil)
        sendButton!.touchDownEvent = {
            self.resetPassword()
        }
        sendButton!.disable()
        self.view.addSubview(sendButton!)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let email = textField.text {
            if EmailUtil.isValidEmail(email: email) {
                resetPassword()
            }
        }
        return true
    }
    
    private func resetPassword() {
        if let email = emailTextField.text {
            if (EmailUtil.isValidEmail(email: email)) {
                if !isResettingPassword && !sendButton!.isWaiting {
                    sendButton!.enterTempState(text: "正在发送...")
                    let resetPasswordRequest: ResetPasswordRequest = ResetPasswordRequest()
                    resetPasswordRequest.email = email
                    isResettingPassword = true
                    AccountManager(serviceConfiguration: ParseConfiguration()).resetPassword(resetPasswordRequest, responseHandler: { (response) in
                        if response == nil {
                            AlertUtil.showGeneralErrorAlert(target: self, buttonAction: #selector(self.dismissAlert))
                        } else if response?.success != nil && response?.success == true {
                            OperationQueue.main.addOperation {
                                self.isResettingPassword = false
                                self.sendButton?.startWaiting()
                            }
                        } else if response?.error?.code != nil {
                            self.sendButton!.endTempState()
                            AlertUtil.showErrorAlert(errorCode: response?.error?.code, target: self, buttonAction: #selector(self.dismissAlert))
                        } else {
                            AlertUtil.showGeneralErrorAlert(target: self, buttonAction: #selector(self.dismissAlert))
                        }
                    })
                }
            }
        }
    }
    
    func didChangeText(_ textField:UITextField) {
        if textField.text != nil && EmailUtil.isValidEmail(email: textField.text!) {
            sendButton!.enable()
        } else {
            sendButton!.disable()
        }
    }
    
        
    func dismissAlert() {
        self.isResettingPassword = false
    }

}
