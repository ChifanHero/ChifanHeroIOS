//
//  ListsTableViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 8/20/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class ListsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var lists : [List] = []
    
    var request : GetListsRequest?
    
//    @IBOutlet weak var filterBlurView: UIVisualEffectView!
    
    @IBOutlet weak var tableView: UITableView!
    
//    private var filterPanelHeight : CGFloat = 128
//    
//    var filterPanelOpening = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        filterBlurView.frame.size.height = 0
        loadTableData()
    }
    
    func loadTableData() {
        if request != nil {
            DataAccessor(serviceConfiguration: ParseConfiguration()).getLists(request!) { (response) -> Void in
                self.lists = (response?.results)!
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                });
            }
        }
    }
    
    
//    @IBAction func toggleFilterPanel(sender: AnyObject) {
//        if !filterPanelOpening {
//            openFilterPanel()
//        } else {
//            closeFilterPanel()
//        }
//        
//    }
    
//    @IBAction func confirmFilterOptions(sender: AnyObject) {
//        closeFilterPanel()
//    }
    
//    private func closeFilterPanel() {
//        UIView.animateWithDuration(0.2, animations: { () -> Void in
//            self.filterBlurView.frame.size.height = 0
//            }) { (finish) -> Void in
//                self.filterPanelOpening = false
//        }
//    }
    
//    private func openFilterPanel() {
//        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.4, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
//            self.filterBlurView.frame.size.height = self.filterPanelHeight
//            }) { (finish) -> Void in
//                self.filterPanelOpening = true
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10
//    }
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor.groupTableViewBackgroundColor()
//        return headerView
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return lists.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : ListTableViewCell? = tableView.dequeueReusableCellWithIdentifier("listCell") as? ListTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "listCell")
            cell = tableView.dequeueReusableCellWithIdentifier("listCell") as? ListTableViewCell
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let restaurantCell : ListTableViewCell = cell as! ListTableViewCell
        restaurantCell.model = lists[indexPath.row]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showList", sender: lists[indexPath.section])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showList" {
            let listMemberController : ListMemberViewController = segue.destinationViewController as! ListMemberViewController
            listMemberController.listId = (sender as! List).id
        }
    }

}
