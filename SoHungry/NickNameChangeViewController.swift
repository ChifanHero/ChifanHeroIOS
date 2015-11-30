//
//  NameChangeViewController.swift
//  SoHungry
//
//  Created by Zhang, Alex on 11/11/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class NickNameChangeViewController: UIViewController {

    @IBOutlet weak var nickNameTextField: UITextField!
    
    @IBAction func nickNameChangeDone(sender: AnyObject) {
        
        if nickNameTextField.text != nil {
            
            AccountManager(serviceConfiguration: ParseConfiguration()).updateInfo(nickName: nickNameTextField.text, pictureId: nil) { (success, user) -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    if success == true {
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
