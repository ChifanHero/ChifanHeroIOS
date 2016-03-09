//
//  AboutMeDetailTableViewController.swift
//  SoHungry
//
//  Created by Zhang, Alex on 11/11/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class AboutMeDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: ImageProgressiveTableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
//    @IBOutlet weak var aboutMeDetailViewTitle: UINavigationItem!
    
    var detailType: FavoriteTypeEnum? {
        didSet {
            if self.detailType == FavoriteTypeEnum.Restaurant{
//                aboutMeDetailViewTitle.title = "我想去的"
            } else if self.detailType == FavoriteTypeEnum.Dish {
//                aboutMeDetailViewTitle.title = "我想吃的"
            } else {
//                aboutMeDetailViewTitle.title = "我的榜单"
            }
            
        }
    }
    
    var favorites: [Favorite]?
    var restaurants: [Restaurant] = [Restaurant]()
    var dishes: [Dish] = [Dish]()
    var lists: [List] = [List]()
    
    var restaurantImages = [PhotoRecord]()
    var dishImages = [PhotoRecord]()
    var listImages = [PhotoRecord]()
    
    var ratingAndFavoriteExecutor: RatingAndBookmarkExecutor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if detailType == FavoriteTypeEnum.Dish {
            self.tableView.allowsSelection = false
        }
        ratingAndFavoriteExecutor = RatingAndBookmarkExecutor(baseVC: self)
        registerCell()
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
    
    func refresh() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func registerCell(){
        tableView.registerNib(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: "restaurantCell")
        tableView.registerNib(UINib(nibName: "NameImageDishCell", bundle: nil), forCellReuseIdentifier: "nameImageDishCell")
        tableView.registerNib(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "listCell")
    }
    
    private func loadData(){
        self.tableView.hidden = true
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        let request: GetFavoritesRequest = GetFavoritesRequest(type: self.detailType!)
        
        DataAccessor(serviceConfiguration: ParseConfiguration()).getFavorites(request) { (response) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.favorites = (response?.results)
                for var index = 0; index < self.favorites?.count; index++ {
                    if self.favorites![index].type == "restaurant" {
                        self.restaurants.append(self.favorites![index].restaurant!)
                        self.fetchRestaurantImageDetails()
                    } else if self.favorites![index].type == "dish" {
                        self.dishes.append(self.favorites![index].dish!)
                        self.fetchDishImageDetails()
                    } else {
                        self.lists.append(self.favorites![index].list!)
                    }
                }
                
                
                self.tableView.reloadData()
                self.tableView.hidden = false
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
            });
        }
    }
    
    private func fetchRestaurantImageDetails() {
        for restaurant: Restaurant in self.restaurants {
            var url = restaurant.picture?.original
            if url == nil {
                url = ""
            }
            let record = PhotoRecord(name: "", url: NSURL(string: url!)!)
            self.restaurantImages.append(record)
        }
    }
    
    private func fetchDishImageDetails() {
        for dish: Dish in self.dishes {
            var url = dish.picture?.original
            if url == nil {
                url = ""
            }
            let record = PhotoRecord(name: "", url: NSURL(string: url!)!)
            self.dishImages.append(record)
        }
    }
    
    private func fetchListImageDetails() {
        for list: List in self.lists {
            var url = list.picture?.original
            if url == nil {
                url = ""
            }
            let record = PhotoRecord(name: "", url: NSURL(string: url!)!, defaultImage: nil)
            self.listImages.append(record)
        }
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if self.detailType == FavoriteTypeEnum.Restaurant{
            return self.restaurants.count
        } else if self.detailType == FavoriteTypeEnum.Dish {
            return self.dishes.count
        } else {
            return self.lists.count
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        if detailType == FavoriteTypeEnum.Restaurant {
            let cell: RestaurantTableViewCell? = tableView.dequeueReusableCellWithIdentifier("restaurantCell") as? RestaurantTableViewCell
            cell?.setUp(restaurant: restaurants[indexPath.section], image: restaurantImages[indexPath.section].image!)
            return cell!
        } else if self.detailType == FavoriteTypeEnum.Dish {
            let cell: NameImageDishTableViewCell? = tableView.dequeueReusableCellWithIdentifier("nameImageDishCell") as? NameImageDishTableViewCell
            cell?.setUp(dish: dishes[indexPath.section], image: dishImages[indexPath.section].image!)
            return cell!
        } else {
            let cell: ListTableViewCell? = tableView.dequeueReusableCellWithIdentifier("listCell") as? ListTableViewCell
            let imageDetails = imageForIndexPath(tableView: tableView, indexPath: indexPath)
            cell?.setUp(list: lists[indexPath.section], image: imageDetails.image!)
            return cell!
        }
    }
    
    func imageForIndexPath(tableView tableView : UITableView, indexPath : NSIndexPath) -> PhotoRecord {
        if self.detailType == FavoriteTypeEnum.Restaurant {
            if indexPath.section > restaurantImages.count - 1 {
                return PhotoRecord.DEFAULT
            } else {
                return self.restaurantImages[indexPath.section]
            }
            
            
        } else if self.detailType == FavoriteTypeEnum.Dish {
            if indexPath.section > dishImages.count - 1 {
                return PhotoRecord.DEFAULT
            } else {
                return self.dishImages[indexPath.section]
            }
            
            
        } else {
            if indexPath.section > listImages.count - 1 {
                return PhotoRecord.DEFAULT
            } else {
                return self.listImages[indexPath.section]
            }
            
        }
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.favorites![indexPath.row].type == "restaurant" {
            let restaurantSelected : Restaurant = restaurants[indexPath.section]
            performSegueWithIdentifier("AboutMeDetailToRestaurant", sender: restaurantSelected.id)
        } else if self.favorites![indexPath.row].type == "dish" {
            
        } else {
            let listSelected : List = lists[indexPath.section]
            performSegueWithIdentifier("AboutMeDetailToList", sender: listSelected.id)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if detailType == FavoriteTypeEnum.Restaurant {
            return RestaurantTableViewCell.height
        } else if self.detailType == FavoriteTypeEnum.Dish {
            return NameImageDishTableViewCell.height
        } else {
            return ListTableViewCell.height
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 10
        }
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        return headerView
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let addBookmarkAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "取消收藏", handler:{(action, indexpath) -> Void in
            
            self.removeFavorite(indexPath)
            
        });
        addBookmarkAction.backgroundColor = UIColor(red: 0, green: 0.749, blue: 1, alpha: 1.0);
        
        return [addBookmarkAction];
    }
    
    private func removeFavorite(indexPath: NSIndexPath){
        if detailType == FavoriteTypeEnum.Restaurant{
            let restaurant = self.restaurants[indexPath.section]
            ratingAndFavoriteExecutor?.removeFavorite("restaurant", objectId: restaurant.id!, successHandler: { () -> Void in
                self.restaurants.removeAtIndex(indexPath.section)
                self.restaurantImages.removeAtIndex(indexPath.section)
                self.tableView.reloadData()
            })
        } else if detailType == FavoriteTypeEnum.Dish{
            let dish = self.dishes[indexPath.section]
            ratingAndFavoriteExecutor?.removeFavorite("dish", objectId: dish.id!, successHandler: { () -> Void in
                self.dishes.removeAtIndex(indexPath.section)
                self.dishImages.removeAtIndex(indexPath.section)
                self.tableView.reloadData()
            })
        } else {
            let lish = self.lists[indexPath.section]
            ratingAndFavoriteExecutor?.removeFavorite("lish", objectId: lish.id!, successHandler: { () -> Void in
                self.lists.removeAtIndex(indexPath.section)
                self.tableView.reloadData()
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AboutMeDetailToRestaurant" {
            let restaurantController : RestaurantViewController = segue.destinationViewController as! RestaurantViewController
            restaurantController.restaurantId = sender as? String
        } else if segue.identifier == "AboutMeDetailToList" {
            let listMemberController: ListMemberViewController = segue.destinationViewController as! ListMemberViewController
            listMemberController.listId = sender as? String
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
