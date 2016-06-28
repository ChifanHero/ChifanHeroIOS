//
//  NameChangeViewController.swift
//  SoHungry
//
//  Created by Zhang, Alex on 11/11/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class NickNameChangeViewController: UITableViewController, UITextFieldDelegate {
    
    var nickName : String?

    @IBOutlet weak var nickNameTextField: UITextField!
    
    @IBAction func nickNameChangeDone(sender: AnyObject) {
        
        changeNickName()
    }
    
    func changeNickName() {
        if nickNameTextField.text != nil {
            
            AccountManager(serviceConfiguration: ParseConfiguration()).updateInfo(nickName: nickNameTextField.text, pictureId: nil) { (response) -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    if response!.success == true {
                        print("Update nick name succeed")
                    } else {
                        print("Update nick name failed")
                    }
                    self.navigationController?.popViewControllerAnimated(true)
                })
                
            }
        } else {
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addImageForBackBarButtonItem()
        self.nickNameTextField.text = self.nickName
        self.nickNameTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        setTabBarVisible(false, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        TrackingUtil.trackUserNicknameChangeView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print(self.nickNameTextField.text)
        if self.nickNameTextField.text == "" || self.nickNameTextField.text == nil {
            return false
        } else {
            changeNickName()
            return true
        }
        
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
