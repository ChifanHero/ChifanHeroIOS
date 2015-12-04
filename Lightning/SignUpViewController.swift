//
//  SignUpViewController.swift
//  SoHungry
//
//  Created by Zhang, Alex on 11/1/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, SignUpDelegate{
    
    var loginViewController: LoginViewController?
    
    var signUpView: SignUpView?

    override func viewDidLoad() {
        super.viewDidLoad()
        signUpView = SignUpView(frame: CGRectMake(0, 0, view.frame.size.width, view.frame.size.height))
        signUpView?.delegate = self
        view.addSubview(signUpView!)
        
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
    
    func confirm() {
        AccountManager(serviceConfiguration: ParseConfiguration()).signUp(username: (signUpView?.usernameText)!, password: (signUpView?.passwordText)!){(success) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                if success == true {
                    self.loginViewController?.replaceLoginViewByAboutMeView()
                    self.navigationController?.popViewControllerAnimated(true)
                } else{
                    print("fail")
                }
            });
            
        }
        
    }
    
    func cancel() {
        
    }

}
