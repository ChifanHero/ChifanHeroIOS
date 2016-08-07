//
//  LocationHelper.swift
//  Lightning
//
//  Created by Shi Yan on 5/18/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import MapKit
import CoreData

class LocationHelper {
    
    class func getCityNameFromLocation(lat : Double, lon : Double, completionHandler: (City) -> Void) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lon))
        let f = CLPlacemark()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
//            // Address dictionary
//            print(placeMark.addressDictionary)
//            
//            // Location name
//            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
//                print(locationName)
//            }
//            
//            // Street address
//            if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
//                print(street)
//            }
            
            // City
            let cityObject : City = City()
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                cityObject.name = city as String
            }
            if let state = placeMark.addressDictionary!["State"] as? NSString {
                cityObject.state = state as String
            }

            // Zip code
            if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
                cityObject.zip = zip as String
            }
            
            // Country
            if let country = placeMark.addressDictionary!["Country"] as? NSString {
                cityObject.localizedCountryName = country as String
            }
            cityObject.activated = true
            completionHandler(cityObject)
        }
    }
    
    class func getDefaultCityFromCoreData() -> City? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "DefaultCity")
        do {
            if let results = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                if results.count != 0 {
                    let managedObject = results[0]
                    let defaultCity = City()
                    defaultCity.name = managedObject.valueForKey("name") as? String
                    defaultCity.state = managedObject.valueForKey("state") as? String
                    defaultCity.zip = managedObject.valueForKey("zip") as? String
                    defaultCity.localizedCountryName = managedObject.valueForKey("localized_country_name") as? String
                    let center = Location()
                    center.lat = managedObject.valueForKey("center_lat") as? Double
                    center.lon = managedObject.valueForKey("center_lon") as? Double
                    defaultCity.center = center
                    return defaultCity
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return getDefaultCity()
    }
    
    class func saveDefaultCityToCoreData(city : City) {
        print("saving default city")
        clearDataForEntity("DefaultCity")
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "DefaultCity")
        do {
            if let results = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                var managedObject : NSManagedObject
                print("default cities count = \(results.count)")
                if results.count != 0 {
                    managedObject = results[0]
                } else {
                    let entity = NSEntityDescription.entityForName("DefaultCity", inManagedObjectContext: managedContext)
                    managedObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                }
                managedObject.setValue(city.name, forKey: "name")
                managedObject.setValue(city.state, forKey: "state")
                managedObject.setValue(city.zip, forKey: "zip")
                managedObject.setValue(city.localizedCountryName, forKey: "localized_country_name")
                managedObject.setValue(city.center?.lat, forKey: "center_lat")
                managedObject.setValue(city.center?.lon, forKey: "center_lon")
                do {
                    try managedContext.save()
                    NSNotificationCenter.defaultCenter().postNotificationName("DefaultCityChanged", object: nil)
                } catch let error as NSError {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        saveCityToHistory(city)
    }
    
    class func saveCityToHistory(city : City) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "EverUsedCity")
        do {
            if let results = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                var managedObject : NSManagedObject?
                if results.count != 0 {
                    for savedCity : NSManagedObject in results {
                        var savedCityName = savedCity.valueForKey("name") as! String?
                        if savedCityName == nil {
                            savedCityName = ""
                        }
                        if (savedCityName == city.name!) {
                            managedObject = savedCity
                            break
                        }
                    }
                }
                if managedObject == nil {
                    let entity = NSEntityDescription.entityForName("EverUsedCity", inManagedObjectContext: managedContext)
                    managedObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                    managedObject!.setValue(city.name, forKey: "name")
                    managedObject!.setValue(city.state, forKey: "state")
                    managedObject!.setValue(city.zip, forKey: "zip")
                    managedObject!.setValue(city.localizedCountryName, forKey: "localized_country_name")
                    managedObject!.setValue(city.center?.lat, forKey: "center_lat")
                    managedObject!.setValue(city.center?.lon, forKey: "center_lon")
                }
                do {
                    managedObject?.setValue(NSDate().timeIntervalSince1970, forKey: "last_used_time")
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    class func getDefaultCity() -> City {
        let defaultCity = City()
        let center = Location()
        center.lat = 37.317492
        center.lon = -122.041949
        defaultCity.center = center
        defaultCity.name = "Cupertino"
        defaultCity.state = "CA"
        defaultCity.zip = "95014"
        defaultCity.localizedCountryName = "USA"
        return defaultCity
    }
    
    class func getEverUsedCities(count : Int) -> [City] {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "EverUsedCity")
        let sortDescriptor : NSSortDescriptor = NSSortDescriptor(key: "last_used_time", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        var everUsedCities = [City]()
        do {
            if let results = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                if results.count != 0 {
                    
                    for city : NSManagedObject in results {
                        if everUsedCities.count >= count {
                            break
                        }
                        let usedCity = City()
                        usedCity.name = city.valueForKey("name") as? String
                        usedCity.state = city.valueForKey("state") as? String
                        usedCity.zip = city.valueForKey("zip") as? String
                        usedCity.localizedCountryName = city.valueForKey("localized_country_name") as? String
                        let center = Location()
                        center.lat = city.valueForKey("center_lat") as? Double
                        center.lon = city.valueForKey("center_lon") as? Double
                        usedCity.center = center
                        everUsedCities.append(usedCity)
                        
                    }
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return everUsedCities
    }
    
    class func getHotCities(count : Int) -> [City] {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "HotCity")
        var hotCities = [City]()
        do {
            if let results = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                if results.count != 0 {
                    
                    for city : NSManagedObject in results {
                        if hotCities.count >= count {
                            break
                        }
                        let hotCity = City()
                        hotCity.name = city.valueForKey("name") as? String
                        hotCity.state = city.valueForKey("state") as? String
                        hotCity.zip = city.valueForKey("zip") as? String
                        hotCity.localizedCountryName = city.valueForKey("localized_country_name") as? String
                        let center = Location()
                        center.lat = city.valueForKey("center_lat") as? Double
                        center.lon = city.valueForKey("center_lon") as? Double
                        hotCity.center = center
                        hotCities.append(hotCity)
                        
                    }
                } else {
                    hotCities.appendContentsOf(getDefaultHotCites())
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return hotCities
    }
    
    class func getDefaultHotCites() -> [City] {
        
        var hotCities = [City]()
        
        let cupertino = City()
        let cupertinoCenter = Location()
        cupertinoCenter.lat = 37.317492
        cupertinoCenter.lon = -122.041949
        cupertino.center = cupertinoCenter
        cupertino.name = "Cupertino"
        cupertino.state = "CA"
        cupertino.zip = "95014"
        cupertino.localizedCountryName = "USA"
        hotCities.append(cupertino)
        
        let sanJose = City()
        let sanJoseCenter = Location()
        sanJoseCenter.lat = 37.3382082
        sanJoseCenter.lon = -121.88632860000001
        sanJose.center = sanJoseCenter
        sanJose.name = "San Jose"
        sanJose.state = "CA"
        sanJose.zip = "95101"
        sanJose.localizedCountryName = "USA"
        hotCities.append(sanJose)
        
        let sanFrancisco = City()
        let sanFranciscoCenter = Location()
        sanFranciscoCenter.lat = 37.7749295
        sanFranciscoCenter.lon = -122.41941550000001
        sanFrancisco.center = sanFranciscoCenter
        sanFrancisco.name = "San Francisco"
        sanFrancisco.state = "CA"
        sanFrancisco.zip = "94101"
        sanFrancisco.localizedCountryName = "USA"
        hotCities.append(sanFrancisco)
        
        let sunnyVale = City()
        let sunnyValeCenter = Location()
        sunnyValeCenter.lat = 37.36883
        sunnyValeCenter.lon = -122.0363496
        sunnyVale.center = sunnyValeCenter
        sunnyVale.name = "Sunnyvale"
        sunnyVale.state = "CA"
        sunnyVale.zip = "94085"
        sunnyVale.localizedCountryName = "USA"
        hotCities.append(sunnyVale)
        
        let losAngeles = City()
        let losAngelesCenter = Location()
        losAngelesCenter.lat = 34.0522342
        losAngelesCenter.lon = -118.2436849
        losAngeles.center = losAngelesCenter
        losAngeles.name = "Los Angeles"
        losAngeles.state = "CA"
        losAngeles.zip = "90001"
        losAngeles.localizedCountryName = "USA"
        hotCities.append(losAngeles)
        
        return hotCities
    }
    
    class func saveHotCities(hotCities : [City]) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "HotCity")
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.deleteObject(managedObjectData)
            }
        } catch let error as NSError {
            print("Could not delete all data in HotCity error : \(error) \(error.userInfo)")
        }
        
        let entity = NSEntityDescription.entityForName("HotCity", inManagedObjectContext: managedContext)
        for city in hotCities {
            let managedObject : NSManagedObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
            managedObject.setValue(city.name, forKey: "name")
            managedObject.setValue(city.state, forKey: "state")
            managedObject.setValue(city.zip, forKey: "zip")
            managedObject.setValue(city.localizedCountryName, forKey: "localized_country_name")
            managedObject.setValue(city.center?.lat, forKey: "center_lat")
            managedObject.setValue(city.center?.lon, forKey: "center_lon")
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    class func clearDataForEntity(entityName : String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.deleteObject(managedObjectData)
            }
        } catch let error as NSError {
            print("Could not delete all data in HotCity error : \(error) \(error.userInfo)")
        }
    }
}
