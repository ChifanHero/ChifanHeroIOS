//
//  ReviewsViewController.swift
//  Lightning
//
//  Created by Shi Yan on 10/3/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu

class ReviewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var reviewsTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configDropDownMenu()
        addBarButton()
        self.addImageForBackBarButtonItem()
        self.clearTitleForBackBarButtonItem()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configDropDownMenu() {
        let items = ["按时间", "默认"]
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "评论排序", items: items)
        self.navigationItem.titleView = menuView
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
//            menuView
//            self.selectedCellLabel.text = "排序: \(items[indexPath])"
        }
    }
    
    private func addBarButton() {
        let addNewReviewButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(ReviewsViewController.addNewReview))
        self.navigationItem.rightBarButtonItem = addNewReviewButton
    }
    
    func addNewReview() {
        self.performSegueWithIdentifier("writeReview", sender: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: ReviewSnapshotTableViewCell? = tableView.dequeueReusableCellWithIdentifier("reviewSnapshotCell") as? ReviewSnapshotTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "ReviewSnapshotCell", bundle: nil), forCellReuseIdentifier: "reviewSnapshotCell")
            cell = tableView.dequeueReusableCellWithIdentifier("reviewSnapshotCell") as? ReviewSnapshotTableViewCell
        }
        if indexPath.section == 2 {
            cell?.userName = "Peter Huang"
            cell?.profileImageView.image = UIImage(named: "peter")
            cell?.review = "Who tm cares?"
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 166
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        return footerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        showReview()
        cell.selected = false
    }
    
    func showReview() {
        performSegueWithIdentifier("showReview", sender: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
