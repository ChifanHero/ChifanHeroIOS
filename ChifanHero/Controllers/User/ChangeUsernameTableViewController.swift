//
//  ChangeUsernameTableViewController.swift
//  ChifanHero
//
//  Created by Shi Yan on 9/10/17.
//  Copyright © 2017 Lightning. All rights reserved.
//

import UIKit

class ChangeUsernameTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    var username: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        usernameTextField.delegate = self
        usernameTextField.text = username
        addDoneButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func usernameChangeDone(_ sender: Any) {
        changeUsername()
    }
    
    private func addDoneButton() {
        let button: UIButton = ButtonUtil.barButtonWithTextAndBorder("完成", size: CGRect(x: 0, y: 0, width: 80, height: 26))
        button.addTarget(self, action: #selector(ChangeUsernameTableViewController.usernameChangeDone(_:)), for: UIControlEvents.touchUpInside)
        let filterButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = filterButton
    }
    
    private func changeUsername() {
        if usernameTextField.text == nil || usernameTextField.text!.trimmingCharacters(in: .whitespaces).characters.count == 0 {
            AlertUtil.showAlertView(buttonText: "我知道了", infoTitle: "用户名不能为空", infoSubTitle: "", target: self, buttonAction: #selector(self.dismissAlert))
        } else {
            AccountManager(serviceConfiguration: ParseConfiguration()).updateInfo(nickName: nil, pictureId: nil, email: nil, username: usernameTextField.text, responseHandler: { (response) in
                OperationQueue.main.addOperation({ () -> Void in
                    if response == nil {
                        AlertUtil.showGeneralErrorAlert(target: self, buttonAction: #selector(self.dismissAlert))
                    } else if response!.success == true {
                        print("Update username succeed")
                        self.navigationController?.popViewController(animated: true)
                    } else if response?.error?.code != nil {
                        AlertUtil.showErrorAlert(errorCode: response?.error?.code, target: self, buttonAction: #selector(self.dismissAlert))
                    } else {
                        AlertUtil.showGeneralErrorAlert(target: self, buttonAction: #selector(self.dismissAlert))
                    }
                    
                })
            })
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        changeUsername()
        return true
    }
    
    func dismissAlert() {
        
    }

}
