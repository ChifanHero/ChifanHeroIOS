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
                } else {
                    return nil
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return nil
    }
    
    class func saveDefaultCityToCoreData(city : City) {
        print("saving default city")
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "DefaultCity")
        do {
            if let results = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                var managedObject : NSManagedObject
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
}
