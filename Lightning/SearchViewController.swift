//
//  SearchViewController.swift
//  Lightning
//
//  Created by Shi Yan on 8/5/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

let searchContext : SearchContext = SearchContext()

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var addressContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var addressBar: UITextField!
    
    @IBOutlet weak var searchBar: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        addressBar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
        self.view.layoutIfNeeded()
        self.addressContainerHeight.constant = 44
        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 6.0, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            // Do nothing
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: AnyObject) {
        let tabBarController = self.tabBarController
//        searchContext.keyword = "iphone"
//        let tabBarController = self.tabBarController
//        let selectedIndex = tabBarController!.selectedIndex
//        print(selectedIndex)
        
//        self.dismissViewControllerAnimated(false, completion: nil)
//        let storyboard = UIStoryboard(name: "RestaurantsAndSearch", bundle: nil)
        
        
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
