//
//  AboutMeDetailTableViewController.swift
//  SoHungry
//
//  Created by Zhang, Alex on 11/11/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class AboutMeDetailViewController: RefreshableViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var detailType: FavoriteTypeEnum?
    
    var favorites: [Favorite]?
    var restaurants: [Restaurant] = [Restaurant]()
    var dishes: [Dish] = [Dish]()
    var selectedCollections: [SelectedCollection] = [SelectedCollection]()
    
    @IBOutlet weak var noFavoritesMessage: UILabel!
    
    var ratingAndFavoriteExecutor: RatingAndBookmarkExecutor?
    
    let refreshControl = Respinner(spinningView: UIImageView(image: UIImage(named: "Pull_Refresh")))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if detailType == FavoriteTypeEnum.Dish {
            self.tableView.allowsSelection = false
        }
        refreshControl.addTarget(self, action: #selector(AboutMeDetailViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.insertSubview(self.refreshControl, atIndex: 0)
        ratingAndFavoriteExecutor = RatingAndBookmarkExecutor(baseVC: self)
        registerCell()
        displayLoadingView()
        loadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        let selectedCellIndexPath : NSIndexPath? = self.tableView.indexPathForSelectedRow
        if selectedCellIndexPath != nil {
            self.tableView.deselectRowAtIndexPath(selectedCellIndexPath!, animated: false)
        }
    }
    
    private func displayLoadingView(){
        self.tableView.hidden = true
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
    }
    
    @objc private func refresh(sender:AnyObject) {
        refreshData()
    }
    
    override func refreshData() {
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func registerCell(){
        tableView.registerNib(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: "restaurantCell")
        tableView.registerNib(UINib(nibName: "NameImageDishCell", bundle: nil), forCellReuseIdentifier: "nameImageDishCell")
        tableView.registerNib(UINib(nibName: "SelectedCollectionCell", bundle: nil), forCellReuseIdentifier: "selectedCollectionCell")
    }
    
    private func loadData(){
        let request: GetFavoritesRequest = GetFavoritesRequest(type: self.detailType!)
        
        DataAccessor(serviceConfiguration: ParseConfiguration()).getFavorites(request) { (response) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.clearData()
                self.favorites = (response?.results)
                for var index = 0; index < self.favorites?.count; index += 1 {
                    if self.favorites![index].type == "restaurant" {
                        self.restaurants.append(self.favorites![index].restaurant!)
                    } else if self.favorites![index].type == "dish" {
                        self.dishes.append(self.favorites![index].dish!)
                    } else {
                        self.selectedCollections.append(self.favorites![index].selectedCollection!)
                    }
                }
                if self.restaurants.count > 0 || self.dishes.count > 0 || self.selectedCollections.count > 0 {
                    self.tableView.hidden = false
                    self.noFavoritesMessage.hidden = true
                    self.tableView.reloadData()
                } else {
                    self.noFavoritesMessage.hidden = false
                }
                
                self.refreshControl.endRefreshing()
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
            });
        }
    }
    
    private func clearData() {
        self.restaurants.removeAll()
        self.dishes.removeAll()
        self.selectedCollections.removeAll()
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.detailType == FavoriteTypeEnum.Restaurant{
            return self.restaurants.count
        } else if self.detailType == FavoriteTypeEnum.Dish {
            return self.dishes.count
        } else {
            return self.selectedCollections.count
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        if detailType == FavoriteTypeEnum.Restaurant {
            let cell: RestaurantTableViewCell? = tableView.dequeueReusableCellWithIdentifier("restaurantCell") as? RestaurantTableViewCell
            cell?.setUp(restaurant: restaurants[indexPath.row])
            return cell!
        } else if self.detailType == FavoriteTypeEnum.Dish {
            let cell: NameImageDishTableViewCell? = tableView.dequeueReusableCellWithIdentifier("nameImageDishCell") as? NameImageDishTableViewCell
            cell?.setUp(dish: dishes[indexPath.row])
            return cell!
        } else {
            let cell: SelectedCollectionTableViewCell? = tableView.dequeueReusableCellWithIdentifier("selectedCollectionCell") as? SelectedCollectionTableViewCell
            cell?.setUp(selectedCollection: selectedCollections[indexPath.row])
            return cell!
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.favorites![indexPath.row].type == "restaurant" {
            let restaurantSelected : Restaurant = restaurants[indexPath.row]
            performSegueWithIdentifier("AboutMeDetailToRestaurant", sender: restaurantSelected.id)
        } else if self.favorites![indexPath.row].type == "dish" {
            
        } else {
            let selectedCollectionSelected: SelectedCollection = selectedCollections[indexPath.row]
            performSegueWithIdentifier("AboutMeDetailToList", sender: selectedCollectionSelected.id)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if detailType == FavoriteTypeEnum.Restaurant {
            return RestaurantTableViewCell.height
        } else if self.detailType == FavoriteTypeEnum.Dish {
            return NameImageDishTableViewCell.height
        } else {
            return SelectedCollectionTableViewCell.height
        }
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AboutMeDetailToRestaurant" {
            let restaurantController : RestaurantViewController = segue.destinationViewController as! RestaurantViewController
            restaurantController.restaurantId = sender as? String
        } else if segue.identifier == "AboutMeDetailToList" {
            //let listMemberController: ListMemberViewController = segue.destinationViewController as! ListMemberViewController
            //listMemberController.listId = sender as? String
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}