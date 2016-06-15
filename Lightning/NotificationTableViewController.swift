//
//  NotificationViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 8/5/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit
import CoreData
import Flurry_iOS_SDK

protocol NotificationSelectionDelegate {
    func notificationSelected(notification : NSManagedObject)
}

class NotificationTableViewController: UITableViewController, UISplitViewControllerDelegate {
    
    var notifications = [NSManagedObject]()
    private var foregroundNotification: NSObjectProtocol!
    
    var detailNavigationController : UINavigationController?
    
    var delegate : NotificationSelectionDelegate?
    
    let refreshCtrl = Respinner(spinningView: UIImageView(image: UIImage(named: "Pull_Refresh")))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NotificationTableViewController.notificationArrived), name:"NotificationArrived", object: nil)
        clearTitleForBackBarButtonItem()
        configurePullRefresh()
        let editBarButton = UIBarButtonItem(title: "编辑", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(NotificationTableViewController.edit))
        editBarButton.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = editBarButton
        self.splitViewController?.delegate = self
//        loadNotificationsInBackground()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTableData()
        TrackingUtil.trackNotificationsView()
    }
    
    private func configurePullRefresh(){
        self.refreshCtrl.addTarget(self, action: #selector(NotificationTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshCtrl)
    }
    
    @objc private func refresh(sender:AnyObject) {
        loadTableData()
    }
    
//    func loadNotificationsInBackground() {
//        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
//        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
//        dispatch_async(backgroundQueue, {
//            self.loadTableData()
//        })
//    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        clearTableViewSelection()
//        loadTableData()
        
    }
    
    private func clearTitleForBackBarButtonItem(){
        let barButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = barButtonItem
    }
    
    private func clearTableViewSelection() {
        let selectedCellIndexPath : NSIndexPath? = self.tableView.indexPathForSelectedRow
        if selectedCellIndexPath != nil {
            self.tableView.deselectRowAtIndexPath(selectedCellIndexPath!, animated: false)
        }
    }
    
    func notificationArrived() {
        loadTableData()
        recalculateBadgeValue()
//        let indexPath : NSIndexPath = NSIndexPath(forRow: self.notifications.count - 1, inSection: 0)
//        self.tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.Top)
    }
    
    func recalculateBadgeValue() {
        let badgeValue : Int = countNumberOfUnreadItems()
        if badgeValue > 0 {
            self.navigationController?.splitViewController?.tabBarItem.badgeValue = "\(badgeValue)"
            UIApplication.sharedApplication().applicationIconBadgeNumber = badgeValue;
        } else {
            self.navigationController?.splitViewController?.tabBarItem.badgeValue = nil
            UIApplication.sharedApplication().applicationIconBadgeNumber = 0;
        }
    }
    
    func loadTableData() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Notification")
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            notifications = results as! [NSManagedObject]
            print(notifications.count)
            self.tableView.reloadData()
            self.refreshCtrl.endRefreshing()
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : NotificationTableViewCell? = tableView.dequeueReusableCellWithIdentifier("notificationCell") as? NotificationTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "notificationCell")
            cell = tableView.dequeueReusableCellWithIdentifier("notificationCell") as? NotificationTableViewCell
        }
        let notification = notifications[indexPath.row]
        let title = notification.valueForKey("title") as! String
        let body = notification.valueForKey("body") as! String
        let read = notification.valueForKey("read") as! Bool
        cell?.setUp(title: title, body: body, read: read)
        return cell!
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let notificationSelected : NSManagedObject = notifications[indexPath.row]
        markNotificationAsRead(notificationSelected)
        self.delegate?.notificationSelected(notificationSelected)
//        if let detailViewController = self.delegate as? NotificationDetailViewController {
//            self.navigationController?.splitViewController?.showDetailViewController(detailViewController.navigationController!, sender: nil)
//            
//            
//        }
        self.navigationController?.splitViewController?.showDetailViewController(self.detailNavigationController!, sender: nil)
//        performSegueWithIdentifier("showMessage", sender: notificationSelected)
    }
    
    private func markNotificationAsRead(notification : NSManagedObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        if (notification.valueForKey("read"))! as! Bool == false {
            notification.setValue(true, forKey: "read")
            do {
                try managedContext.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            recalculateBadgeValue()
        }
    }
    
    private func countNumberOfUnreadItems() -> Int{
        var count = 0
        for item : NSManagedObject in self.notifications {
            let read : Bool = item.valueForKey("read") as! Bool
            if read == false {
                count += 1
            }
        }
        return count
    }
    
    func edit() {
        let doneBarButton = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Done, target: self, action: #selector(NotificationTableViewController.done))
        doneBarButton.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = doneBarButton
        self.tableView.editing = true
        
    }
    
    func done() {
        let editBarButton = UIBarButtonItem(title: "编辑", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(NotificationTableViewController.edit))
        editBarButton.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = editBarButton
        self.tableView.editing = false
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let deletedObject : NSManagedObject = self.notifications.removeAtIndex(indexPath.row)
            clearDetailView()
            deleteFromCoreData(deletedObject)
            self.tableView.beginUpdates()
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
            self.tableView.endUpdates()
        }
    }
    
    func clearDetailView() {
        if let detailViewController = self.delegate as? NotificationDetailViewController {
            detailViewController.clear()
        }
    }
    
    private func deleteFromCoreData(object : NSManagedObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        managedContext.deleteObject(object)
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        clearTableViewSelection()
        return true
    }
    
    
    
    

}
