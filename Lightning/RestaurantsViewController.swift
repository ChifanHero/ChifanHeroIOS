//
//  RestaurantsViewController.swift
//  Lightning
//
//  Created by Shi Yan on 8/5/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

let searchContext : SearchContext = SearchContext()

class RestaurantsViewController: UIViewController, UITextFieldDelegate {
    
    var containerViewController : RestaurantsContainerViewController?
    
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    @IBOutlet weak var searchBar: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
//        filterButton.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        setDefaultSearchContext()
    }
    
    private func setDefaultSearchContext() {
        searchContext.distance = RangeFilter.TWENTY
        searchContext.rating = RatingFilter.FOUR
        searchContext.sort = SortOptions.RATING
        searchContext.newSearch = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        print("restaurants view did appear")
        super.viewDidAppear(animated)
        performNewSearchIfNeeded()
    }
    
    // MARK - TextField methods
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        performSegueWithIdentifier("search", sender: nil)
        return false
    }
    
    func performNewSearchIfNeeded() {
        if searchContext.newSearch {
            print("filter view just closed. should do a new search here")
            print("keyword = \(searchContext.keyword)")
            print("range = \(searchContext.distance)")
            print("rating = \(searchContext.rating)")
            print("sort = \(searchContext.sort)")
            searchContext.newSearch = false
        } else {
            print("filter view just closed, but no new search needed")
        }
        
    }


    @IBAction func openFilter(sender: AnyObject) {
        self.containerViewController?.slideMenuController()?.openRight()
    }

}
