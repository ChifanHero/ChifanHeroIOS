//
//  LoginViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 10/3/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, LoginDelegate {
    
    @IBOutlet weak var loginView: LoginView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func logIn() {
//        self.performSegueWithIdentifier("showUser", sender: self)
        AccountManager(serviceConfiguration: ParseConfiguration()).logIn(username: self.loginView.username, password: self.loginView.password) { (success, user) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                if success == true {
                    self.replaceLoginViewByAboutMeView()
                } else {
                    print("login failed")
                    self.showErrorMessage()
                }
            })
            
        }
        
    }
    
    private func showErrorMessage() {
        
    }
    
    func replaceLoginViewByAboutMeView() {
        let tabBarController : UITabBarController = UIApplication.sharedApplication().keyWindow?.rootViewController as! UITabBarController
        var viewControllers = tabBarController.viewControllers!
        for var index = 0; index < viewControllers.count; index++ {
            let vc : UIViewController = viewControllers[index]
            if vc.restorationIdentifier == "LoginNavigationController" {
                viewControllers.removeAtIndex(index)
                let aboutMeNC = getAboutMeNavigationController()
                viewControllers.insert(aboutMeNC, atIndex: index)
                break
            }
        }
        tabBarController.setViewControllers(viewControllers, animated: false)
    }
    
    func getAboutMeNavigationController() -> UINavigationController {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let aboutMeNC : UINavigationController = storyBoard.instantiateViewControllerWithIdentifier("AboutMeNavigationController") as! UINavigationController
        aboutMeNC.tabBarItem = UITabBarItem(title: "About me", image: UIImage(named: "about me"), tag: 3)
        return aboutMeNC
    }
    
    func logInWithSina() {
        
    }
    
    func signUp() {
        
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "showUser" {
////            let destinationVC : UIViewController = segue.destinationViewController
////            self.navigationController?.topViewController = destinationVC
//            
//            
//        }
//    }

}
