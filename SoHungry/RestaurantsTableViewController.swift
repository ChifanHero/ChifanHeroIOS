//
//  RestaurantsTableViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 8/20/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class RestaurantsTableViewController: UITableViewController, ImageProgressiveTableViewDelegate {
    
    @IBOutlet var restaurantsTable: ImageProgressiveTableView!
    
    var request : GetRestaurantsRequest?
    
    var restaurants : [Restaurant] = []
    
    var pendingOperations = PendingOperations()
    var images = [PhotoRecord]()
    
    var indicatorContainer : UIView?
    var indicator : UIActivityIndicatorView?
    
    var loadMoreIndicator : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    let footerView : LoadMoreFooterView = LoadMoreFooterView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.restaurantsTable.imageDelegate = self
        setupIndicator()
        loadTableData()
    }
    
    func loadTableData() {
        self.showIndicator()
        if request != nil {
            DataAccessor(serviceConfiguration: ParseConfiguration()).getRestaurants(request!) { (response) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.restaurants = (response?.results)!
                    self.fetchImageDetails()
//                    self.dismissIndicator()
                    self.tableView.reloadData()
//                    self.tableView.hidden = false
                    //self.dismissIndicator()
                });
            }
        }
    }
    
    private func fetchImageDetails() {
        for restaurant : Restaurant in self.restaurants {
            let url = restaurant.picture?.original
            if url != nil {
                let record = PhotoRecord(name: "", url: NSURL(string: url!)!)
                self.images.append(record)
            }
        }
    }
    
    func setupIndicator() {
        indicatorContainer = UIView(frame: self.view.frame)
        indicatorContainer?.opaque = true
        indicatorContainer?.backgroundColor = UIColor.blackColor()
        indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        indicator?.center = self.view.center
        indicatorContainer?.addSubview(indicator!)
    }
    
    func showIndicator() {
        indicator?.startAnimating()
    }
    
    func dismissIndicator() {
        indicator?.stopAnimating()
        indicatorContainer?.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return RestaurantTableViewCell.height
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 10
        }
        
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        return headerView
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return restaurants.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : RestaurantTableViewCell? = tableView.dequeueReusableCellWithIdentifier("restaurantCell") as? RestaurantTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: "restaurantCell")
            cell = tableView.dequeueReusableCellWithIdentifier("restaurantCell") as? RestaurantTableViewCell
        }
        let imageDetails = imageForIndexPath(tableView: self.restaurantsTable, indexPath: indexPath)
        cell?.setUp(restaurant: restaurants[indexPath.section], image: imageDetails.image!)
        
        switch (imageDetails.state){
        case .New:
            self.restaurantsTable.startOperationsForPhotoRecord(&pendingOperations, photoDetails: imageDetails,indexPath:indexPath)
        default: break
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // if last row, do: load more data
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let restaurantSelected : Restaurant = restaurants[indexPath.row]
        performSegueWithIdentifier("showRestaurant", sender: restaurantSelected.id)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRestaurant" {
            let restaurantController : RestaurantViewController = segue.destinationViewController as! RestaurantViewController
            restaurantController.restaurantId = sender as? String
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        // if last section, add activity indicator
        if section == restaurants.count - 1 {
            footerView.activityIndicator.startAnimating()
            // load more data
        }
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // add footer to last section
        return footerView
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == restaurants.count - 1 {
           return 30
        } else {
            return 0
        }
        
    }
    
    func imageForIndexPath(tableView tableView : UITableView, indexPath : NSIndexPath) -> PhotoRecord {
        return self.images[indexPath.section]
    }

}
