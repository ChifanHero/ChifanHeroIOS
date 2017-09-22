//
//  NameChangeViewController.swift
//  SoHungry
//
//  Created by Zhang, Alex on 11/11/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class ChangeNicknameTableViewController: UITableViewController, UITextFieldDelegate {
    
    var nickName : String?

    @IBOutlet weak var nickNameTextField: UITextField!
    
    @IBAction func nickNameChangeDone(_ sender: AnyObject) {
        changeNickName()
    }
    
    func changeNickName() {
        guard nickNameTextField.text != nil && nickNameTextField.text!.trimmingCharacters(in: .whitespaces).characters.count != 0 else {
            AlertUtil.showAlertView(buttonText: "我知道了", infoTitle: "请输入昵称", infoSubTitle: "昵称不能为空", target: self, buttonAction: #selector(self.dismissAlert))
            return
        }
        AccountManager(serviceConfiguration: ParseConfiguration()).updateInfo(nickName: nickNameTextField.text, pictureId: nil) { (response) -> Void in
            OperationQueue.main.addOperation({ () -> Void in
                if response == nil {
                    AlertUtil.showGeneralErrorAlert(target: self, buttonAction: #selector(self.dismissAlert))
                } else if response?.success != nil && response?.success == true {
                    log.debug("Nickname update successful")
                    self.navigationController?.popViewController(animated: true)
                } else if response?.error?.code != nil {
                    AlertUtil.showErrorAlert(errorCode: response?.error?.code, target: self, buttonAction: #selector(self.dismissAlert))
                } else {
                    AlertUtil.showGeneralErrorAlert(target: self, buttonAction: #selector(self.dismissAlert))
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addImageForBackBarButtonItem()
        self.nickNameTextField.text = self.nickName
        self.nickNameTextField.delegate = self
        addDoneButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        setTabBarVisible(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TrackingUtil.trackUserNicknameChangeView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addDoneButton() {
        let button: UIButton = ButtonUtil.barButtonWithTextAndBorder("完成", size: CGRect(x: 0, y: 0, width: 80, height: 26))
        button.addTarget(self, action: #selector(ChangeNicknameTableViewController.nickNameChangeDone(_:)), for: UIControlEvents.touchUpInside)
        let filterButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = filterButton
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        changeNickName()
        return true
    }
    
    func dismissAlert() {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
