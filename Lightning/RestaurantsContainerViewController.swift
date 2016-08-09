//
//  RestaurantsContainerViewController.swift
//  Lightning
//
//  Created by Shi Yan on 8/5/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class RestaurantsContainerViewController: SlideMenuController, SlideMenuControllerDelegate {
    
    var restaurantsVC : RestaurantsViewController?
    var filterVC : RestaurantsFilterViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        SlideMenuOptions.contentViewScale = 1.00
        SlideMenuOptions.rightViewWidth = 250
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func awakeFromNib() {
        if let controller : UINavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("RestaurantsNavigation") as? UINavigationController {
            self.mainViewController = controller
            let mainVC : RestaurantsViewController = controller.viewControllers[0] as! RestaurantsViewController
            mainVC.containerViewController = self
            self.restaurantsVC = mainVC
        }
        if let controller : UINavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("RestaurantsFilter") as? UINavigationController{
            self.rightViewController = controller
            let filterVC : RestaurantsFilterViewController = controller.viewControllers[0] as! RestaurantsFilterViewController
            filterVC.containerVC = self
            self.filterVC = filterVC
        }
        super.awakeFromNib()
    }
    
    func rightWillOpen() {
        filterVC?.updateFilters()
    }
    
    func rightDidClose() {
        restaurantsVC?.performNewSearchIfNeeded(true)
    }
    

}