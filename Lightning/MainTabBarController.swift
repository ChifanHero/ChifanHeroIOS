//
//  MainTabBarController.swift
//  Lightning
//
//  Created by Shi Yan on 9/25/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        createChildrenControllers()
       // setTabBarIcons()
       //let tabBarItems = tabBar.items! as [UITabBarItem]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setTabBarIcons() {
        
    }
    
    private func createChildrenControllers() {
        let homeStoryBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let homePageViewController: UIViewController = homeStoryBoard.instantiateViewControllerWithIdentifier("HomeNavigationController") as UIViewController
        
        let restaurantsStoryboard:UIStoryboard = UIStoryboard(name: "RestaurantsAndSearch", bundle: nil)
        let restaurantsViewController:UIViewController = restaurantsStoryboard.instantiateViewControllerWithIdentifier("RestaurantsContainer") as UIViewController
        
        let selectionsStoryBoard: UIStoryboard = UIStoryboard(name: "Collection", bundle: nil)
        let selectionsViewController: UIViewController = selectionsStoryBoard.instantiateViewControllerWithIdentifier("CollectionsNavigationController") as UIViewController
        
        let userStoryBoard: UIStoryboard = UIStoryboard(name: "User", bundle: nil)
        let usersViewController: UIViewController = userStoryBoard.instantiateViewControllerWithIdentifier("LogInNavigationController") as UIViewController
        
        
        self.viewControllers = [homePageViewController, restaurantsViewController, selectionsViewController, usersViewController]
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        print("tapped")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
