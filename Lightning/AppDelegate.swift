//
//  AppDelegate.swift
//  Lightning
//
//  Created by Shi Yan on 7/29/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import UIKit
import Parse
import CoreData
import SCLAlertView

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?

    let locationManager = CLLocationManager()
    
    var currentLocation : Location = Location()
    
    var application : UIApplication?
    var launchOptions : [NSObject: AnyObject]?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.application = application
        self.launchOptions = launchOptions
        // Override point for customization after application launch.
        Parse.setApplicationId("Z6ND8ho1yR4aY3NSq1zNNU0kPc0GDOD1UZJ5rgxM", clientKey: "t9TxZ7HPgwEl84gH9A2R9qisn8giNIdtKuAyt9Q4")
//        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
//        registerForPushNotifications()
        UISetup()
        configSplitViewController()
        configNavigationBar()
//        startGettingLocation()
        if launchOptions != nil && launchOptions![UIApplicationLaunchOptionsRemoteNotificationKey] != nil {
            print("Did receive push notification in launching") // Will be called when app is not active in background
            // show notification page
            let notification : [NSObject : AnyObject] = launchOptions![UIApplicationLaunchOptionsRemoteNotificationKey] as! [NSObject : AnyObject]
            handleNotification(notification)
        }
        handleFirstLaunch()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return true
    }
    
    private func UISetup() {
        UITextField.appearance().tintColor = UIColor.blueColor()
    }
    
    private func configNavigationBar() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    private func handleFirstLaunch() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if !defaults.boolForKey("hasLaunchedOnce") {
            createFirstNotification()
//            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
//            let storyboard = UIStoryboard(name: "Tutorial", bundle: nil)
//            let tutorialViewController = storyboard.instantiateViewControllerWithIdentifier("tutorialInitial")
//            self.window?.rootViewController = tutorialViewController
//            self.window?.makeKeyAndVisible()
//            defaults.setBool(true, forKey: "hasLaunchedOnce")
//            defaults.synchronize()
        }
        setBadgeValue()
        
    }
    
    private func createFirstNotification() {
        let title = FirstNotification.title
        let body = FirstNotification.body
        saveNotifications(title: title, body: body)
    }
    
    private func setBadgeValue() {
        let badgeValue = countUnreadNotifications()
        let tabBarController : UITabBarController = self.window!.rootViewController as! UITabBarController
        //let splitViewController : UISplitViewController = tabBarController.viewControllers![3] as! UISplitViewController
        if badgeValue > 0 {
            //splitViewController.tabBarItem.badgeValue = "\(badgeValue)"
            UIApplication.sharedApplication().applicationIconBadgeNumber = badgeValue;
        } else {
            //splitViewController.tabBarItem.badgeValue = nil
            UIApplication.sharedApplication().applicationIconBadgeNumber = 0;
        }

    }
    
    private func handleNotification(notification : [NSObject : AnyObject]) {
        print(notification)
        let aps = notification["aps"] as? NSDictionary
        var title : String = ""
        var body : String = ""
        if let parameter = notification["parameters"] as? NSDictionary {
            title = parameter["title"] as! String
//            title = parameter.objectForKey("title") as! String
            body = parameter["body"] as! String
            let save = parameter["save"] as! Int
            if save == 1 {
                saveNotifications(title: title, body: body)
                if application!.applicationState != UIApplicationState.Active {
                    let tabBarController : UITabBarController = self.window!.rootViewController as! UITabBarController
                    let splitViewController : UISplitViewController = tabBarController.viewControllers![3] as! UISplitViewController
                    tabBarController.selectedViewController = splitViewController
                }
                
            }
        } else {
            if aps != nil {
                title = aps!["alert"] as! String
                body = aps!["alert"] as! String
            }
            
        }
    }
    
    private func countUnreadNotifications() -> Int {
        let fetchRequest = NSFetchRequest(entityName: "Notification")
        var notifications : [NSManagedObject] = [NSManagedObject]()
        var count = 0
        do {
            let results =
            try self.managedObjectContext.executeFetchRequest(fetchRequest)
            notifications = results as! [NSManagedObject]
            for item : NSManagedObject in notifications {
                let read : Bool = item.valueForKey("read") as! Bool
                if read == false {
                    count += 1
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return count
    }
    
    private func saveNotifications(title title : String, body : String) {
        let entity = NSEntityDescription.entityForName("Notification", inManagedObjectContext: self.managedObjectContext)
        let notification = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.managedObjectContext)
        notification.setValue(title, forKey: "title")
        notification.setValue(body, forKey: "body")
        notification.setValue(false, forKey: "read")
        do {
            try self.managedObjectContext.save()
            NSNotificationCenter.defaultCenter().postNotificationName("NotificationArrived", object: nil)
            print("Saved notification")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func startGettingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func requestLocationAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
    
    private func configSplitViewController() {
        let tabBarController : UITabBarController = self.window!.rootViewController as! UITabBarController
        var viewControllers = tabBarController.viewControllers!
        for index in 0 ..< viewControllers.count {
            let vc : UIViewController = viewControllers[index]
            if vc.restorationIdentifier == "splitViewController" {
                let splitViewController = vc as! UISplitViewController


                let detailNavigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
                detailNavigationController.navigationBar.tintColor = UIColor.whiteColor()
                detailNavigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
                let detailController = detailNavigationController.topViewController as! NotificationDetailViewController
                detailController.navigationItem.leftItemsSupplementBackButton = true
//                splitViewController.delegate = self
                let masterNavigationController = splitViewController.viewControllers[0] as! UINavigationController
                masterNavigationController.navigationBar.tintColor = UIColor.whiteColor()
                let masterController = masterNavigationController.topViewController as! NotificationTableViewController
                
                masterController.delegate = detailController
                masterController.detailNavigationController = detailNavigationController
                detailController.navigationItem.leftBarButtonItem = detailController.splitViewController?.displayModeButtonItem()
                
//                controller.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                break
            }
        }
    }
    
    func registerForPushNotifications() {
        // Register for Push Notitications
//        if application.applicationState != UIApplicationState.Background {
//            // Track an app open here if we launch with a push, unless
//            // "content_available" was used to trigger a background push (introduced in iOS 7).
//            // In that case, we skip tracking here to avoid double counting the app-open.
//            
//            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
//            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
//            var pushPayload = false
//            if let options = launchOptions {
//                pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
//            }
//            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
//                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
//            }
//        }
        if application!.respondsToSelector(#selector(UIApplication.registerUserNotificationSettings(_:))) {
            //view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
            let settings = UIUserNotificationSettings(forTypes: [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound], categories: nil)
            application!.registerUserNotificationSettings(settings)
            application!.registerForRemoteNotifications()
        } else {
            application!.registerForRemoteNotifications()
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        informUserLocationSettingsIfNecessary()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        // Get user device token and save to parse
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    // Will be called when app is active in background
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("Did receive push notification")
        handleNotification(userInfo)
        
    }
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        currentLocation.lat = locValue.latitude
        currentLocation.lon = locValue.longitude
        NSNotificationCenter.defaultCenter().postNotificationName("UserLocationAvailable", object: currentLocation)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        // user denied to share location. Set default location to user last used city and show alert
        if error.code == CLError.Denied.rawValue {
            manager.stopUpdatingLocation()
            handleLocationPermissionDenied()
            informUserLocationSettingsIfNecessary()
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch (status) {
        case (CLAuthorizationStatus.NotDetermined):
            // not determined
            break
        case (CLAuthorizationStatus.Denied):
            // user denied location permission
            manager.stopUpdatingLocation()
            handleLocationPermissionDenied()
            break
        case (CLAuthorizationStatus.Authorized):
            // user granted location permission
            manager.startUpdatingLocation()
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(false, forKey: "needsToInformedUserLocationChange")
            defaults.synchronize()
            break
        default:
            break
        }
    }
    
    private func handleLocationPermissionDenied() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "needsToInformedUserLocationChange")
        defaults.synchronize()
        
    }
    
    private func informUserLocationSettingsIfNecessary() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.boolForKey("needsToInformedUserLocationChange") {
            let rootVC : UIViewController? = self.window?.rootViewController
            if rootVC != nil {
                let appearance = SCLAlertView.SCLAppearance(kWindowWidth: rootVC!.view.frame.size.width - 120, showCloseButton: false, showCircularIcon: false, kTitleHeight : 0)
                let askLocationAlertView : SCLAlertView? = SCLAlertView(appearance: appearance)
                askLocationAlertView!.addButton("我知道了", backgroundColor: LightningColor.themeRed(), target:self, selector:#selector(AppDelegate.doNothing))
                askLocationAlertView!.showInfo("", subTitle: "\n\n您现在的城市为：XXX\n\n", closeButtonTitle: "", duration: 0.0, colorStyle: LightningColor.themeRed().getColorCode(), colorTextButton: 0xFFFFFF, circleIconImage: nil)
            }
            
            defaults.setBool(false, forKey: "needsToInformedUserLocationChange")
            defaults.synchronize()
        }
    }
    
    @objc private func doNothing() {
        
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.so.hungry.CoreData2" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Lightning", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            let options = [ NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true ]
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as! NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    


}

