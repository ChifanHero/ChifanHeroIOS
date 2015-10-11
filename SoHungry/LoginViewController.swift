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
    var horizontalLoginView : HorizontalLoginView?
    var currentLoginView : LoginView?
    var previousLoginView : LoginView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLoginPanel()
    }
    
    private func setUpLoginPanel() {
        if view.frame.size.width > view.frame.size.height {
            horizontalLoginView = HorizontalLoginView(frame: CGRectMake(0, 0, view.frame.size.width, view.frame.size.height))
            view.addSubview(horizontalLoginView!)
            currentLoginView = horizontalLoginView
        } else {
            verticalLoginView = VerticalLoginView(frame: CGRectMake(0, 0, view.frame.size.width, view.frame.size.height))
            view.addSubview(verticalLoginView!)
            currentLoginView = verticalLoginView
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func logIn(account account : String?, password : String?) {
//        self.performSegueWithIdentifier("showUser", sender: self)
//        AccountManager(serviceConfiguration: ParseConfiguration()).logIn(username: self.loginView!.username, password: self.loginView!.password) { (success, user) -> Void in
//            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                if success == true {
//                    self.replaceLoginViewByAboutMeView()
//                } else {
//                    print("login failed")
//                    self.showErrorMessage()
//                }
//            })
//            
//        }
        
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
    
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        coordinator.animateAlongsideTransition({ (transitionCoordinatorContext) -> Void in
            // Place code here to perform animations during the rotation. Pass nil or leave this block empty if not necessary
            self.setupNewLoginView(size)
            }) { (transitionCoordinatorContext) -> Void in
                // Code here will execute after the rotation has finished
                
        }
    }
    
    private func setupNewLoginView(size : CGSize) {
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
        currentLoginView?.indicatorActivate = (previousLoginView?.indicatorActivate)!
        previousLoginView?.removeFromSuperview()
        self.view.addSubview(currentLoginView!)
        
    }


}
