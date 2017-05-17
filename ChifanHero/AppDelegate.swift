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
import Flurry_iOS_SDK
import GooglePlaces

let userLocationManager: UserLocationManager = UserLocationManager()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?

    let locationManager = CLLocationManager()
    
    var application : UIApplication?
    var launchOptions : [AnyHashable: Any]?
    
    var isAppInForeground = false
    
    var postLocationAvailableNotification = true

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        isAppInForeground = true
        self.application = application
        self.launchOptions = launchOptions
        initialize()
        if launchOptions != nil && launchOptions![UIApplicationLaunchOptionsKey.remoteNotification] != nil {
            print("Did receive push notification in launching") // Will be called when app is not active in background
            // show notification page
            let notification : [AnyHashable: Any] = launchOptions![UIApplicationLaunchOptionsKey.remoteNotification] as! [AnyHashable: Any]
            handleNotification(notification)
        }
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        return handled
    }
    
    // MARK: - Initialization
    
    fileprivate func initialize() {
        Parse.setApplicationId("Z6ND8ho1yR4aY3NSq1zNNU0kPc0GDOD1UZJ5rgxM", clientKey: "t9TxZ7HPgwEl84gH9A2R9qisn8giNIdtKuAyt9Q4")
        GMSPlacesClient.provideAPIKey("AIzaSyDoBwLxj_Ij9SnIwfKD7khalqjUObIs6xE")
        #if DEBUG
            print("debug mode")
            Flurry.startSession("N4DY3VDK76YVF8S72RZ7")
        #else
            print("release mode")
            Flurry.startSession("PFBPXT8FVS35SWZVT68C")
        #endif
        observeDefaultCityChanges()
        loadInitializationData()
        UISetup()
        handleFirstLaunch()
        setBadgeValue()
    }
    
    fileprivate func UISetup() {
        configNavigationBar()
    }
    
    fileprivate func observeDefaultCityChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.informUserLocationSettingsIfNecessary), name:NSNotification.Name(rawValue: "DefaultCityChanged"), object: nil)
    }
    
    fileprivate func loadInitializationData() {
        loadHotCitiesInBackground()
    }
    
    fileprivate func loadHotCitiesInBackground() {
        let hotCityRequest : GetHotCitiesRequest = GetHotCitiesRequest()
        DataAccessor(serviceConfiguration: ParseConfiguration()).getHotCities(hotCityRequest) { (searchResponse) in
            if let results = searchResponse?.results {
                var hotCities = [City]()
                hotCities.append(contentsOf: results)
                LocationHelper.saveHotCities(hotCities)
            }
        }
    }
    
    fileprivate func configNavigationBar() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().barTintColor = UIColor.themeOrange()
    }
    
    fileprivate func handleFirstLaunch() {
        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: "hasLaunchedOnce") {
            NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.keyWindowLoaded), name:NSNotification.Name(rawValue: "HomeVCLoaded"), object: nil)
            initializeUserDefaults()
            createFirstNotification()
            trackAppVersion()
            defaults.set(true, forKey: "hasLaunchedOnce")
            defaults.synchronize()
        } else {
            // Common logic. Needed everytime user start the app.
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func keyWindowLoaded() {
        prepareForNotificationAuthorization()
        askForLocationAuthorization()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HomeVCLoaded"), object: nil)
    }
    
    fileprivate func initializeUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "usingCustomLocation")
        defaults.synchronize()
    }
    
    fileprivate func prepareForNotificationAuthorization() {
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.registerSystemNotifications), name:NSNotification.Name(rawValue: "locationAlertDismissed"), object: nil)
    }
    
    func registerSystemNotifications() {
        registerForPushNotifications()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "locationAlertDismissed"), object: nil)
    }
    
    fileprivate func askForLocationAuthorization() {
        let rootVC : UIViewController? = self.window?.rootViewController
        if rootVC != nil {
            let appearance = SCLAlertView.SCLAppearance(kCircleIconHeight: 40.0, showCloseButton: false, showCircularIcon: true)
            let askLocationAlertView = SCLAlertView(appearance: appearance)
            let alertViewIcon = UIImage(named: "LogoWithBorder")
            askLocationAlertView.addButton("我知道了", backgroundColor: UIColor.themeOrange(), target:self, selector:#selector(AppDelegate.askLocationAlertViewDismissed))
            askLocationAlertView.showInfo("友情提示", subTitle: "\n\n允许位置服务可以帮助吃饭英雄精确搜索。\n\n如果您不希望共享位置，我们将为您设置一个默认城市。您可以随时去首页左上角“位置”重新设置。", colorStyle: UIColor.themeOrange().getColorCode(), circleIconImage: alertViewIcon)
            
        }
        
    }
    
    func askLocationAlertViewDismissed() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    fileprivate func trackAppVersion() {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            Flurry.logEvent("AppVersion" + version)
        }
    }
    
    fileprivate func createFirstNotification() {
        let title = FirstNotification.title
        let body = FirstNotification.body
        saveNotifications(title: title, body: body)
    }
    
    fileprivate func setBadgeValue() {
        let badgeValue = countUnreadNotifications()
//        let tabBarController : UITabBarController = self.window!.rootViewController as! UITabBarController
//        let splitViewController : UISplitViewController = tabBarController.viewControllers![3] as! UISplitViewController
        if badgeValue > 0 {
            //splitViewController.tabBarItem.badgeValue = "\(badgeValue)"
            UIApplication.shared.applicationIconBadgeNumber = badgeValue;
        } else {
            //splitViewController.tabBarItem.badgeValue = nil
            UIApplication.shared.applicationIconBadgeNumber = 0;
        }

    }
    
    fileprivate func handleNotification(_ notification : [AnyHashable: Any]) {
        print(notification)
        let aps = notification["aps"] as? NSDictionary
        var title : String = ""
        var body : String = ""
        if let parameter = notification["parameters"] as? NSDictionary {
            title = parameter["title"] as! String
            body = parameter["body"] as! String
            let save = parameter["save"] as! Int
            if save == 1 {
                saveNotifications(title: title, body: body)
                if application!.applicationState != UIApplicationState.active {
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
    
    fileprivate func countUnreadNotifications() -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notification")
        var notifications : [NSManagedObject] = [NSManagedObject]()
        var count = 0
        do {
            let results =
            try self.managedObjectContext.fetch(fetchRequest)
            notifications = results as! [NSManagedObject]
            for item : NSManagedObject in notifications {
                let read : Bool = item.value(forKey: "read") as! Bool
                if read == false {
                    count += 1
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return count
    }
    
    fileprivate func saveNotifications(title : String, body : String) {
        let entity = NSEntityDescription.entity(forEntityName: "Notification", in: self.managedObjectContext)
        let notification = NSManagedObject(entity: entity!, insertInto: self.managedObjectContext)
        notification.setValue(title, forKey: "title")
        notification.setValue(body, forKey: "body")
        notification.setValue(false, forKey: "read")
        do {
            try self.managedObjectContext.save()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "NotificationArrived"), object: nil)
            print("Saved notification")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        isAppInForeground = false
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        isAppInForeground = false
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        isAppInForeground = true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        isAppInForeground = true
//        informUserLocationSettingsIfNecessary()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        isAppInForeground = false
    }
    
    
    // MARK: - Push notifications
    
    func registerForPushNotifications() {
        // Register for Push Notitications
        if application!.responds(to: #selector(UIApplication.registerUserNotificationSettings(_:))) {
            //view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
            let settings = UIUserNotificationSettings(types: [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound], categories: nil)
            application!.registerUserNotificationSettings(settings)
            application!.registerForRemoteNotifications()
        } else {
            application!.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Get user device token and save to parse
        let installation = PFInstallation.current()
        installation.setDeviceTokenFrom(deviceToken)
        installation.saveInBackground()
    }
    
    private func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    // Will be called when app is active in background
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("Did receive push notification")
        handleNotification(userInfo)
        
    }
    
    
    // MARK: - Location management
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        let realtimeLocation = Location()
        realtimeLocation.lat = locValue.latitude
        realtimeLocation.lon = locValue.longitude
        userLocationManager.saveRealtimeLocation(realtimeLocation)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "UserLocationAvailable"), object: nil)

    }
    
    private func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // user denied to share location. Set default location to user last used city and show alert
        if error.code == CLError.Code.denied.rawValue {
            manager.stopUpdatingLocation()
            let defaults = UserDefaults.standard
            if !defaults.bool(forKey: "locationPermissionDenied") {
                TrackingUtil.trackUserDeniedLocation()
                handleLocationPermissionDenied()
            }
            informUserLocationSettingsIfNecessary()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "FailToGetUserLocation"), object: LocationHelper.getDefaultCity().center)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch (status) {
        case (CLAuthorizationStatus.notDetermined):
            // not determined
            break
        case (CLAuthorizationStatus.denied):
            // user denied location permission
            print("denied")
            manager.stopUpdatingLocation()
            let defaults = UserDefaults.standard
            if !defaults.bool(forKey: "locationPermissionDenied") {
                if !defaults.bool(forKey: "usingCustomLocation") {
                    TrackingUtil.trackUserDeniedLocationInSettings()
                    handleLocationPermissionDenied()
                }
                
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: "FailToGetUserLocation"), object: LocationHelper.getDefaultCity().center)
            break
        case (CLAuthorizationStatus.authorizedAlways):
            // user granted location permission
            manager.startUpdatingLocation()
            let defaults = UserDefaults.standard
            defaults.set(false, forKey: "needsToInformedUserLocationChange")
            defaults.set(false, forKey: "locationPermissionDenied")
            defaults.synchronize()
            TrackingUtil.trackUserOpenedLocationInSettings()
            break
        default:
            break
        }
    }
    
    fileprivate func handleLocationPermissionDenied() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "needsToInformedUserLocationChange")
        defaults.set(true, forKey: "locationPermissionDenied")
        defaults.set(true, forKey: "usingCustomLocation")
        defaults.synchronize()
        var defaultCity : City = City()
        let currentLocation = userLocationManager.getLocationInUse()
        if currentLocation != nil && currentLocation!.lat != nil && currentLocation!.lon != nil {
            LocationHelper.getCityNameFromLocation(currentLocation!.lat!, lon: currentLocation!.lon!, completionHandler: { (city) in
                defaultCity = city
                let center = Location()
                center.lat = currentLocation!.lat
                center.lon = currentLocation!.lon
                defaultCity.center = center
                userLocationManager.saveCityInUse(defaultCity)
            })
        } else {
            userLocationManager.saveCityInUse(LocationHelper.getDefaultCity())
        }
        
    }

    
    func informUserLocationSettingsIfNecessary() {
//        let triggerTime = (Int64(NSEC_PER_SEC) * 10)
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
//            
//        })
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "needsToInformedUserLocationChange") && isAppInForeground {
            let rootVC : UIViewController? = self.window?.rootViewController
            if rootVC != nil {
                if let defaultCity = LocationHelper.getDefaultCityFromCoreData() {
                    print("default city is \(defaultCity)")
                    //let alertViewIcon = UIImage(named: "LogoWithBorder")
                    let appearance = SCLAlertView.SCLAppearance(kCircleIconHeight: 40, kTitleHeight : 0, kWindowWidth: rootVC!.view.frame.size.width - 120, showCloseButton: false, showCircularIcon: true)
                    let askLocationAlertView : SCLAlertView? = SCLAlertView(appearance: appearance)
                    askLocationAlertView!.addButton("我知道了", backgroundColor: UIColor.themeOrange(), target:self, selector:#selector(AppDelegate.dismissLocationAlerts))
                    askLocationAlertView!.showInfo("", subTitle: "\n\n您现在的城市为：\(defaultCity.name!)\n\n由于您关闭了位置服务，我们将不再显示餐厅距离.\n\n如果您需要重新使用实时位置，请点击首页左上角“位置”按钮重新选择。")
                    
                }
            }
            defaults.set(false, forKey: "needsToInformedUserLocationChange")
            defaults.synchronize()
            
        }
        
    }
    
    @objc fileprivate func dismissLocationAlerts() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "locationAlertDismissed"), object: nil)
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.so.hungry.CoreData2" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "Lightning", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            let options = [ NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true ]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            
            dict[NSUnderlyingErrorKey] = error as NSError
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
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
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
