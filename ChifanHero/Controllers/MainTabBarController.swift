//
//  MainTabBarController.swift
//  ChifanHero
//
//  Created by Shi Yan on 9/25/16.
//  Copyright © 2016 ChifanHero. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        createChildrenControllers()
    }
    
    fileprivate func createChildrenControllers() {
        let homeStoryBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let homePageViewController: UIViewController = homeStoryBoard.instantiateViewController(withIdentifier: "HomeNavigationController") as UIViewController
        
        let restaurantsStoryboard:UIStoryboard = UIStoryboard(name: "RestaurantsAndSearch", bundle: nil)
        let restaurantsViewController:UIViewController = restaurantsStoryboard.instantiateViewController(withIdentifier: "RestaurantsContainer") as UIViewController
        
        let selectionsStoryBoard: UIStoryboard = UIStoryboard(name: "Collection", bundle: nil)
        let selectionsViewController: UIViewController = selectionsStoryBoard.instantiateViewController(withIdentifier: "CollectionsNavigationController") as UIViewController
        
        let userStoryBoard: UIStoryboard = UIStoryboard(name: "User", bundle: nil)
        let usersViewController: UIViewController = userStoryBoard.instantiateViewController(withIdentifier: "LogInNavigationController") as UIViewController
        
        
        self.viewControllers = [homePageViewController, restaurantsViewController, selectionsViewController, usersViewController]
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
