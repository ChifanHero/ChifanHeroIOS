//
//  RestaurantsFilterViewController.swift
//  Lightning
//
//  Created by Shi Yan on 8/5/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class RestaurantsFilterViewController: UIViewController {
    
    private var sort : SortOptions?
    private var distance : RangeFilter?
    private var rating : RatingFilter?
    
    
    @IBOutlet weak var sortingSC: UISegmentedControl!
    
    @IBOutlet weak var rangeSC: UISegmentedControl!
    
    @IBOutlet weak var ratingSC: UISegmentedControl!
    
    var containerVC : RestaurantsContainerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        addBarButtons()
    }
    
    func addBarButtons() {
        addCancelButton()
        addConfirmButton()
    }
    
    func addCancelButton() {
        let button: UIButton = UIButton.barButtonWithTextAndBorder("取消", size: CGRectMake(0, 0, 80, 26))
        button.addTarget(self, action: #selector(RestaurantsFilterViewController.cancel(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let cancelButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    func addConfirmButton() {
        let button: UIButton = UIButton.barButtonWithTextAndBorder("确定", size: CGRectMake(0, 0, 80, 26))
        button.addTarget(self, action: #selector(RestaurantsFilterViewController.commit(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let confirmButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = confirmButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateFilters() {
        print("Filter view will open, should update filter here")
        updateSortSC()
        updateRangeSC()
        updateRatingSC()
    }
    
    func updateSortSC() {
        let sort = searchContext.sort
        if sort == SortOptions.BESTMATCH {
            sortingSC.selectedSegmentIndex = 0
        } else if sort == SortOptions.RATING {
            sortingSC.selectedSegmentIndex = 1
        } else if sort == SortOptions.DISTANCE {
            sortingSC.selectedSegmentIndex = 2
        } else if sort == SortOptions.HOTNESS {
            sortingSC.selectedSegmentIndex = 3
        }
    }
    
    func updateRangeSC() {
        let range = searchContext.distance
        if range == RangeFilter.AUTO {
            rangeSC.selectedSegmentIndex = 0
        } else if range == RangeFilter.POINT5 {
            rangeSC.selectedSegmentIndex = 1
        } else if range == RangeFilter.ONE {
            rangeSC.selectedSegmentIndex = 2
        } else if range == RangeFilter.FIVE {
            rangeSC.selectedSegmentIndex = 3
        } else if range == RangeFilter.TWENTY {
            rangeSC.selectedSegmentIndex = 4
        }
    }
    
    func updateRatingSC() {
        let rating = searchContext.rating
        if rating == RatingFilter.NONE {
            ratingSC.selectedSegmentIndex = 0
        } else if rating == RatingFilter.THREE {
            ratingSC.selectedSegmentIndex = 1
        } else if rating == RatingFilter.THREEHALF {
            ratingSC.selectedSegmentIndex = 2
        } else if rating == RatingFilter.FOUR {
            ratingSC.selectedSegmentIndex = 3
        } else if rating == RatingFilter.FOURHALF {
            ratingSC.selectedSegmentIndex = 4
        } else if rating == RatingFilter.FIVE {
            ratingSC.selectedSegmentIndex = 5
        }
        
    }
    
    
    func commit(sender: AnyObject) {
        if (distance != nil && distance != searchContext.distance) {
            searchContext.distance = distance!
        }
        if (rating != nil && rating != searchContext.rating) {
            searchContext.rating = rating!
        }
        if (sort != nil && sort != searchContext.sort) {
            searchContext.sort = sort!
        }
        clearStates()
        self.containerVC?.slideMenuController()?.closeRight()
        
    }
    
    func cancel(sender: AnyObject) {
        searchContext.newSearch = false
        clearStates()
        self.containerVC?.slideMenuController()?.closeRight()
    }
    
    private func clearStates() {
        distance = nil
        sort = nil
        rating = nil
    }


    @IBAction func sortingChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            sort = SortOptions.BESTMATCH
        } else if sender.selectedSegmentIndex == 1 {
            sort = SortOptions.RATING
        } else if sender.selectedSegmentIndex == 2 {
            sort = SortOptions.DISTANCE
        } else if sender.selectedSegmentIndex == 3 {
            sort = SortOptions.HOTNESS
        }
    }

    @IBAction func rangeChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            distance = RangeFilter.AUTO
        } else if sender.selectedSegmentIndex == 1{
            distance = RangeFilter.POINT5
        } else if sender.selectedSegmentIndex == 2{
            distance = RangeFilter.ONE
        } else if sender.selectedSegmentIndex == 3{
            distance = RangeFilter.FIVE
        } else if sender.selectedSegmentIndex == 4{
            distance = RangeFilter.TWENTY
        }
    }

    @IBAction func ratingChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            rating = RatingFilter.NONE
        } else if sender.selectedSegmentIndex == 1{
            rating = RatingFilter.THREE
        } else if sender.selectedSegmentIndex == 2{
            rating = RatingFilter.THREEHALF
        } else if sender.selectedSegmentIndex == 3{
            rating = RatingFilter.FOUR
        } else if sender.selectedSegmentIndex == 4{
            rating = RatingFilter.FOURHALF
        } else if sender.selectedSegmentIndex == 5{
            rating = RatingFilter.FIVE
        }
    }
}
