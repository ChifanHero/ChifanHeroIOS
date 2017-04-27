//
//  RestaurantsFilterViewController.swift
//  Lightning
//
//  Created by Shi Yan on 8/5/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class RestaurantsFilterViewController: UIViewController {
    
    fileprivate var sort : SortOptions?
    fileprivate var distance : RangeFilter?
    fileprivate var rating : RatingFilter?
    
    
    @IBOutlet weak var sortingSC: UISegmentedControl!
    
    @IBOutlet weak var rangeSC: UISegmentedControl!
    
    @IBOutlet weak var ratingSC: UISegmentedControl!
    
    var containerVC : RestaurantsContainerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        addBarButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TrackingUtil.trackRestaurantsFilterOpen()
    }
    
    func addBarButtons() {
        addCancelButton()
        addConfirmButton()
    }
    
    func addCancelButton() {
        let button: UIButton = ButtonUtil.barButtonWithTextAndBorder("取消", size: CGRect(x: 0, y: 0, width: 80, height: 26))
        button.addTarget(self, action: #selector(RestaurantsFilterViewController.cancel(_:)), for: UIControlEvents.touchUpInside)
        let cancelButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    func addConfirmButton() {
        let button: UIButton = ButtonUtil.barButtonWithTextAndBorder("确定", size: CGRect(x: 0, y: 0, width: 80, height: 26))
        button.addTarget(self, action: #selector(RestaurantsFilterViewController.commit(_:)), for: UIControlEvents.touchUpInside)
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
        if sort == SortOptions.bestmatch {
            sortingSC.selectedSegmentIndex = 0
        } else if sort == SortOptions.rating {
            sortingSC.selectedSegmentIndex = 1
        } else if sort == SortOptions.distance {
            sortingSC.selectedSegmentIndex = 2
        } else if sort == SortOptions.hotness {
            sortingSC.selectedSegmentIndex = 3
        }
    }
    
    func updateRangeSC() {
        let range = searchContext.distance
        if range == RangeFilter.auto {
            rangeSC.selectedSegmentIndex = 0
        } else if range == RangeFilter.point5 {
            rangeSC.selectedSegmentIndex = 1
        } else if range == RangeFilter.one {
            rangeSC.selectedSegmentIndex = 2
        } else if range == RangeFilter.five {
            rangeSC.selectedSegmentIndex = 3
        } else if range == RangeFilter.twenty {
            rangeSC.selectedSegmentIndex = 4
        }
    }
    
    func updateRatingSC() {
        let rating = searchContext.rating
        if rating == RatingFilter.none {
            ratingSC.selectedSegmentIndex = 0
        } else if rating == RatingFilter.three {
            ratingSC.selectedSegmentIndex = 1
        } else if rating == RatingFilter.threehalf {
            ratingSC.selectedSegmentIndex = 2
        } else if rating == RatingFilter.four {
            ratingSC.selectedSegmentIndex = 3
        } else if rating == RatingFilter.fourhalf {
            ratingSC.selectedSegmentIndex = 4
        } else if rating == RatingFilter.five {
            ratingSC.selectedSegmentIndex = 5
        }
        
    }
    
    
    func commit(_ sender: AnyObject) {
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
    
    func cancel(_ sender: AnyObject) {
        searchContext.newSearch = false
        clearStates()
        self.containerVC?.slideMenuController()?.closeRight()
    }
    
    fileprivate func clearStates() {
        distance = nil
        sort = nil
        rating = nil
    }


    @IBAction func sortingChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            sort = SortOptions.bestmatch
        } else if sender.selectedSegmentIndex == 1 {
            sort = SortOptions.rating
        } else if sender.selectedSegmentIndex == 2 {
            sort = SortOptions.distance
        } else if sender.selectedSegmentIndex == 3 {
            sort = SortOptions.hotness
        }
    }

    @IBAction func rangeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            distance = RangeFilter.auto
        } else if sender.selectedSegmentIndex == 1{
            distance = RangeFilter.point5
        } else if sender.selectedSegmentIndex == 2{
            distance = RangeFilter.one
        } else if sender.selectedSegmentIndex == 3{
            distance = RangeFilter.five
        } else if sender.selectedSegmentIndex == 4{
            distance = RangeFilter.twenty
        }
    }

    @IBAction func ratingChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            rating = RatingFilter.none
        } else if sender.selectedSegmentIndex == 1{
            rating = RatingFilter.three
        } else if sender.selectedSegmentIndex == 2{
            rating = RatingFilter.threehalf
        } else if sender.selectedSegmentIndex == 3{
            rating = RatingFilter.four
        } else if sender.selectedSegmentIndex == 4{
            rating = RatingFilter.fourhalf
        } else if sender.selectedSegmentIndex == 5{
            rating = RatingFilter.five
        }
    }
}
