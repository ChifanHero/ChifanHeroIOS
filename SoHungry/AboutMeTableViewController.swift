//
//  AboutMeTableViewController.swift
//  SoHungry
//
//  Created by Zhang, Alex on 11/9/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class AboutMeTableViewController: UITableViewController {
    

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var favoriteCuisineTypeLabel: UILabel!
    @IBOutlet weak var userLevelLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserInfo()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadUserInfo(){
        let defaults = NSUserDefaults.standardUserDefaults()
        
        favoriteCuisineTypeLabel.hidden = true
        
        if let userPicURL = defaults.stringForKey("userPicURL"){
            userImageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: userPicURL)!)!)
        }
        
        if let nickname = defaults.stringForKey("userNickName"){
            nickNameLabel.text = nickname
        } else{
            nickNameLabel.text = "未设定"
        }
        
        if let userLevel = defaults.stringForKey("userLevel"){
            userLevelLabel.text = userLevel
        } else{
            userLevelLabel.text = "1"
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if indexPath.section == 0 && indexPath.row == 0 {
            
        } else if indexPath.section == 1 && indexPath.row == 0 {
            self.performSegueWithIdentifier("showNickNameChange", sender: indexPath)
        } else if indexPath.section == 2 && indexPath.row == 0 {
            
        } else {
            self.performSegueWithIdentifier("showAboutMeDetail", sender: indexPath)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender!.section == 1 && sender!.row == 1 {
            let destinationVC = segue.destinationViewController as! AboutMeDetailTableViewController
            //destinationVC.detailType = "favoriteCuisineType"
        } else if sender!.section == 3 && sender!.row == 0 {
            let destinationVC = segue.destinationViewController as! AboutMeDetailTableViewController
            destinationVC.detailType = FavoriteTypeEnum.Dish
        } else if sender!.section == 3 && sender!.row == 1 {
            let destinationVC = segue.destinationViewController as! AboutMeDetailTableViewController
            destinationVC.detailType = FavoriteTypeEnum.Restaurant
        } else if sender!.section == 3 && sender!.row == 2 {
            let destinationVC = segue.destinationViewController as! AboutMeDetailTableViewController
            destinationVC.detailType = FavoriteTypeEnum.List
        }
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
