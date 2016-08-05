//
//  RestaurantsContainerViewController.swift
//  Lightning
//
//  Created by Shi Yan on 8/5/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class RestaurantsContainerViewController: SlideMenuController {

    override func viewDidLoad() {
        super.viewDidLoad()
        SlideMenuOptions.contentViewScale = 1.00
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
        }
        if let controller = self.storyboard?.instantiateViewControllerWithIdentifier("RestaurantsFilter") {
            self.rightViewController = controller
        }
        super.awakeFromNib()
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
