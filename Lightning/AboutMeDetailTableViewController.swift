//
//  AboutMeDetailTableViewController.swift
//  SoHungry
//
//  Created by Zhang, Alex on 11/11/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class AboutMeDetailTableViewController: UITableViewController {

    @IBOutlet var AboutMeDetailTableView: UITableView!
    
    var detailType: FavoriteTypeEnum?
    
    var favorites: [Favorite]?
    var restaurants: [Restaurant] = [Restaurant]()
    var dishes: [Dish] = [Dish]()
    var lists: [List] = [List]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        loadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadData(){
        let request: GetFavoritesRequest = GetFavoritesRequest(type: self.detailType!)
        
        DataAccessor(serviceConfiguration: ParseConfiguration()).getFavorites(request) { (response) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.favorites = (response?.results)
                for var index = 0; index < self.favorites?.count; index++ {
                    if self.favorites![index].type == "restaurant" {
                        self.restaurants.append(self.favorites![index].restaurant!)
                    } else if self.favorites![index].type == "dish" {
                        self.dishes.append(self.favorites![index].dish!)
                    } else {
                        self.lists.append(self.favorites![index].list!)
                    }
                }
                self.AboutMeDetailTableView.reloadData()
            });
        }
    }
    
    
    
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.detailType == FavoriteTypeEnum.Restaurant{
            return self.restaurants.count
        } else if self.detailType == FavoriteTypeEnum.Dish {
            return self.dishes.count
        } else {
            return self.lists.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        if self.detailType == FavoriteTypeEnum.Restaurant{
            cell.textLabel!.text = restaurants[indexPath.row].name
        } else if self.detailType == FavoriteTypeEnum.Dish {
            cell.textLabel!.text = dishes[indexPath.row].name
        } else {
            cell.textLabel!.text = lists[indexPath.row].name
        }

        return cell
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
