//
//  ReviewDetailTableViewController.swift
//  ChifanHero
//
//  Created by Shi Yan on 10/30/17.
//  Copyright © 2017 Lightning. All rights reserved.
//

import UIKit
import Kingfisher

class ReviewDetailTableViewController: UITableViewController {
    
    var review: Review!
    var reviewUserProfileImage: UIImage!
    var val: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 300
        self.addImageForBackBarButtonItem()
        self.clearTitleForBackBarButtonItem()
        self.tableView.layoutIfNeeded()
        self.tableView.reloadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 90
        } else if indexPath.row == 2 {
            return val + 10
        } else {
            return UITableViewAutomaticDimension
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let reviewInfoTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "reviewInfoCell") as! ReviewInfoTableViewCell
            reviewInfoTableViewCell.profileImage = reviewUserProfileImage
            reviewInfoTableViewCell.nickName = review.user?.nickName
            reviewInfoTableViewCell.rating = review.rating
            reviewInfoTableViewCell.reviewTime = review.lastUpdateTime
            return reviewInfoTableViewCell
        } else if indexPath.row == 1 {
            let cell: ReviewDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "reviewDetailCell", for: indexPath) as! ReviewDetailTableViewCell
            cell.reviewDetail = review.content
            return cell
        } else {
            let reviewPhotosTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "reviewPhotosCell") as! ReviewPhotosTableViewCell
            reviewPhotosTableViewCell.parentViewController = self
            reviewPhotosTableViewCell.pictures = review.photos
            val = reviewPhotosTableViewCell.photosCollectionView.contentSize.height
            return reviewPhotosTableViewCell
        }
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
