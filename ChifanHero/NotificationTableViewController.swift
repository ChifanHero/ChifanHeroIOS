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

class NotificationTableViewController: UITableViewController {
    
    var notifications = [NSManagedObject]()
    fileprivate var foregroundNotification: NSObjectProtocol!
    
    var detailNavigationController: UINavigationController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(NotificationTableViewController.notificationArrived), name:NSNotification.Name(rawValue: "NotificationArrived"), object: nil)
        self.clearTitleForBackBarButtonItem()
        self.addImageForBackBarButtonItem()
        configurePullRefresh()
        addEditButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTableData()
        TrackingUtil.trackNotificationsView()
    }
    
    fileprivate func addEditButton() {
        let button: UIButton = ButtonUtil.barButtonWithTextAndBorder("编辑", size: CGRect(x: 0, y: 0, width: 80, height: 26))
        button.addTarget(self, action: #selector(NotificationTableViewController.edit), for: UIControlEvents.touchUpInside)
        let editButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    fileprivate func configurePullRefresh(){
    }
    
    @objc fileprivate func refresh(_ sender:AnyObject) {
        loadTableData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearTableViewSelection()
    }
    
    fileprivate func clearTableViewSelection() {
        let selectedCellIndexPath : IndexPath? = self.tableView.indexPathForSelectedRow
        if selectedCellIndexPath != nil {
            self.tableView.deselectRow(at: selectedCellIndexPath!, animated: false)
        }
    }
    
    func notificationArrived() {
        loadTableData()
        recalculateBadgeValue()
    }
    
    func recalculateBadgeValue() {
        let badgeValue: Int = countNumberOfUnreadItems()
        if badgeValue > 0 {
            self.navigationController?.tabBarItem.badgeValue = "\(badgeValue)"
            UIApplication.shared.applicationIconBadgeNumber = badgeValue;
        } else {
            self.navigationController?.tabBarItem.badgeValue = nil
            UIApplication.shared.applicationIconBadgeNumber = 0;
        }
    }
    
    func loadTableData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notification")
        do {
            let results =
            try managedContext.fetch(fetchRequest)
            notifications = results as! [NSManagedObject]
            self.tableView.reloadData()
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: NotificationTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "notificationCell") as? NotificationTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "notificationCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell") as? NotificationTableViewCell
        }
        let notification = notifications[indexPath.row]
        let title = notification.value(forKey: "title") as! String
        let body = notification.value(forKey: "body") as! String
        let read = notification.value(forKey: "read") as! Bool
        cell?.setUp(title: title, body: body, read: read)
        return cell!
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notificationSelected : NSManagedObject = notifications[indexPath.row]
        markNotificationAsRead(notificationSelected)
        performSegue(withIdentifier: "showNotificationDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNotificationDetail" {
            let controller: NotificationDetailViewController = segue.destination as! NotificationDetailViewController
            controller.notificationSelected(notifications[(sender as! IndexPath).row])
        }
    }
    
    fileprivate func markNotificationAsRead(_ notification : NSManagedObject) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        if (notification.value(forKey: "read"))! as! Bool == false {
            notification.setValue(true, forKey: "read")
            do {
                try managedContext.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            recalculateBadgeValue()
        }
    }
    
    fileprivate func countNumberOfUnreadItems() -> Int{
        var count = 0
        for item : NSManagedObject in self.notifications {
            let read : Bool = item.value(forKey: "read") as! Bool
            if read == false {
                count += 1
            }
        }
        return count
    }
    
    func edit() {
        let button: UIButton = ButtonUtil.barButtonWithTextAndBorder("完成", size: CGRect(x: 0, y: 0, width: 80, height: 26))
        button.addTarget(self, action: #selector(NotificationTableViewController.done), for: UIControlEvents.touchUpInside)
        let doneButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = doneButton
        self.tableView.isEditing = true
        
    }
    
    func done() {
        let button: UIButton = ButtonUtil.barButtonWithTextAndBorder("编辑", size: CGRect(x: 0, y: 0, width: 80, height: 26))
        button.addTarget(self, action: #selector(NotificationTableViewController.edit), for: UIControlEvents.touchUpInside)
        let editButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = editButton
        self.tableView.isEditing = false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let deletedObject : NSManagedObject = self.notifications.remove(at: indexPath.row)
            clearDetailView()
            deleteFromCoreData(deletedObject)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.top)
            self.tableView.endUpdates()
        }
    }
    
    func clearDetailView() {
//        if let detailViewController = self.delegate as? NotificationDetailViewController {
//            detailViewController.clear()
//        }
    }
    
    fileprivate func deleteFromCoreData(_ object : NSManagedObject) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        managedContext.delete(object)
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}
