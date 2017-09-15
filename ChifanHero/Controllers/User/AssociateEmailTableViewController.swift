//
//  AssociateEmailTableViewController.swift
//  ChifanHero
//
//  Created by Shi Yan on 9/9/17.
//  Copyright © 2017 Lightning. All rights reserved.
//

import UIKit

class AssociateEmailTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    var sendButton: RetryButton?
    
    var isAssociatingEmail = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false
        emailTextField.delegate = self
        self.configureButton()
        emailTextField.addTarget(self, action: #selector(AssociateEmailTableViewController.didChangeText(_:)), for: .editingChanged)
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
            self.updateEmail()
        }
        sendButton!.disable()
        self.view.addSubview(sendButton!)
    }
    
    func updateEmail() {
        if let email = emailTextField.text {
            if (EmailUtil.isValidEmail(email: email)) {
                if !isAssociatingEmail && !sendButton!.isWaiting {
                    sendButton!.enterTempState(text: "正在发送...")
                    isAssociatingEmail = true
                    AccountManager(serviceConfiguration: ParseConfiguration()).updateInfo(nickName: nil, pictureId: nil, email: emailTextField.text, username: nil, responseHandler: { (response) in
                        if response == nil {
                            AlertUtil.showGeneralErrorAlert(target: self, buttonAction: #selector(self.dismissAlert))
                        } else if response?.success != nil && response?.success == true {
                            OperationQueue.main.addOperation {
                                self.isAssociatingEmail = false
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let email = textField.text {
            if EmailUtil.isValidEmail(email: email) {
                updateEmail()
            }
        }
        return true
    }
    
    func dismissAlert() {
        self.isAssociatingEmail = false
    }
    
    func didChangeText(_ textField:UITextField) {
        if textField.text != nil && EmailUtil.isValidEmail(email: textField.text!) {
            sendButton!.enable()
        } else {
            sendButton!.disable()
        }
    }

}
