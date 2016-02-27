//
//  LoginViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 10/3/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, LoginDelegate {
    
    var verticalLoginView: VerticalLoginView?
    var horizontalLoginView: HorizontalLoginView?
    var currentLoginView: LoginView?
    var previousLoginView: LoginView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isLoggedIn(){
            replaceLoginViewByAboutMeView()
        } else{
            setUpLoginPanel()
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func isLoggedIn() -> Bool{
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let result: Bool? = defaults.boolForKey("isLoggedIn"){
            return result!
        } else{
            return false
        }
    }
    
    private func setUpLoginPanel() {
        if view.frame.size.width > view.frame.size.height {
            horizontalLoginView = HorizontalLoginView(frame: CGRectMake(0, 0, view.frame.size.width, view.frame.size.height))
            view.addSubview(horizontalLoginView!)
            horizontalLoginView?.delegate = self
            
            currentLoginView = horizontalLoginView
        } else {
            verticalLoginView = VerticalLoginView(frame: CGRectMake(0, 0, view.frame.size.width, view.frame.size.height))
            view.addSubview(verticalLoginView!)
            verticalLoginView?.delegate = self
            
            currentLoginView = verticalLoginView
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func logIn(account account : String?, password : String?) {
        
        currentLoginView?.indicator?.startAnimating()
        currentLoginView?.getView()?.addSubview((currentLoginView?.indicator)!)
        
        AccountManager(serviceConfiguration: ParseConfiguration()).logIn(username: self.currentLoginView!.getAccountTextField()!.text, password: self.currentLoginView!.getPasswordTextField()!.text) { (success, user) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                if success == true {
                    let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
                    defaults.setBool(true, forKey: "isLoggedIn")
                    self.replaceLoginViewByAboutMeView()
                } else {
                    print("login failed")
                    self.currentLoginView?.indicator?.stopAnimating()
                    self.currentLoginView?.indicator?.removeFromSuperview()
                    self.showErrorMessage()
                }
            })
            
        }
        
    }
    
    private func showErrorMessage() {
        let alert = UIAlertController(title: "输入错误", message: "请输入有效用户名和密码", preferredStyle: UIAlertControllerStyle.Alert)
        
        let dismissAction = UIAlertAction(title: "知道了", style: .Default, handler: self.resetLogInInput)
        alert.addAction(dismissAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func resetLogInInput(alertAction: UIAlertAction!){
        currentLoginView?.getAccountTextField()!.text = nil
        currentLoginView?.getPasswordTextField()!.text = nil
    }
    
    func replaceLoginViewByAboutMeView() {
        let tabBarController : UITabBarController = UIApplication.sharedApplication().keyWindow?.rootViewController as! UITabBarController
        var viewControllers = tabBarController.viewControllers!
        for var index = 0; index < viewControllers.count; index++ {
            let vc : UIViewController = viewControllers[index]
            if vc.restorationIdentifier == "LogInNavigationController" {
                viewControllers.removeAtIndex(index)
                let aboutMeNC = getAboutMeNavigationController()
                viewControllers.insert(aboutMeNC, atIndex: index)
                break
            }
        }
        tabBarController.setViewControllers(viewControllers, animated: false)
    }
    
    private func getAboutMeNavigationController() -> UINavigationController {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let aboutMeNC : UINavigationController = storyBoard.instantiateViewControllerWithIdentifier("AboutMeNavigationController") as! UINavigationController
        aboutMeNC.tabBarItem = UITabBarItem(title: "About me", image: UIImage(named: "about me"), tag: 3)
        return aboutMeNC
    }
    
    func logInWithSina() {
        
    }
    
    func signUp() {
        performSegueWithIdentifier("signUp", sender: nil)
    }
    
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        coordinator.animateAlongsideTransition({ (transitionCoordinatorContext) -> Void in
            // Place code here to perform animations during the rotation. Pass nil or leave this block empty if not necessary
            self.setupNewLoginView(size)
            }) { (transitionCoordinatorContext) -> Void in
                // Code here will execute after the rotation has finished
                
        }
    }
    
    private func setupNewLoginView(size: CGSize) {
        previousLoginView = currentLoginView
        if (size.width > size.height) {
            
            if horizontalLoginView == nil {
                horizontalLoginView = HorizontalLoginView(frame: CGRectMake(0, 0, size.width, size.height))
            }
            currentLoginView = horizontalLoginView
            
        } else {
            if verticalLoginView == nil {
                verticalLoginView = VerticalLoginView(frame: CGRectMake(0, 0, size.width, size.height))
            }
            currentLoginView = verticalLoginView
        }
        currentLoginView?.account = previousLoginView?.account
        currentLoginView?.password = previousLoginView?.password
        currentLoginView?.errorMessage = previousLoginView?.errorMessage
        previousLoginView?.removeFromSuperview()
        self.view.addSubview(currentLoginView!)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "signUp"){
            let signUpViewController: SignUpViewController = segue.destinationViewController as! SignUpViewController
            signUpViewController.loginViewController = self;
        }
    }


}
