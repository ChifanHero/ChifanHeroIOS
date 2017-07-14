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
    
    class func getLocationFromAddress(_ address: String, completionHandler: @escaping (Location?) -> Void) {
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placeMarks, error) in
            if placeMarks!.count > 0 {
                let topResult: CLPlacemark = placeMarks![0]
                let placemark: MKPlacemark = MKPlacemark(placemark: topResult)
                let latitude = placemark.location!.coordinate.latitude
                let longitude = placemark.location!.coordinate.longitude
                let location: Location = Location()
                location.lat = latitude
                location.lon = longitude
                completionHandler(location)
            }
        }
    }
    
    class func getStreetAddressFromLocation(_ lat : Double, lon : Double, completionHandler: @escaping (String) -> Void) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lon))
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            var placeMark: CLPlacemark!
            placeMark = placemarks![0]
            var address = ""
            var name = ""
            var city = ""
            if placeMark.name != nil {
                name = placeMark.name!
            }
            if placeMark.locality != nil {
                city = placeMark.locality!
            }
            address = "\(name), \(city)"
            completionHandler(address)
        }
    }
    
    class func getCityNameFromLocation(_ lat : Double, lon : Double, completionHandler: @escaping (City) -> Void) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lon))
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            
            var placeMark: CLPlacemark!
            placeMark = placemarks![0]
            
            // City
            let cityObject: City = City()
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DefaultCity")
        do {
            if let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                if results.count != 0 {
                    let managedObject = results[0]
                    let defaultCity = City()
                    defaultCity.name = managedObject.value(forKey: "name") as? String
                    defaultCity.state = managedObject.value(forKey: "state") as? String
                    defaultCity.zip = managedObject.value(forKey: "zip") as? String
                    defaultCity.localizedCountryName = managedObject.value(forKey: "localized_country_name") as? String
                    let center = Location()
                    center.lat = managedObject.value(forKey: "center_lat") as? Double
                    center.lon = managedObject.value(forKey: "center_lon") as? Double
                    defaultCity.center = center
                    return defaultCity
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return getDefaultCity()
    }
    
    class func saveDefaultCityToCoreData(_ city : City) {
        print("saving default city")
        clearDataForEntity("DefaultCity")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DefaultCity")
        do {
            if let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                var managedObject : NSManagedObject
                if results.count != 0 {
                    managedObject = results[0]
                } else {
                    let entity = NSEntityDescription.entity(forEntityName: "DefaultCity", in: managedContext)
                    managedObject = NSManagedObject(entity: entity!, insertInto: managedContext)
                }
                managedObject.setValue(city.name, forKey: "name")
                managedObject.setValue(city.state, forKey: "state")
                managedObject.setValue(city.zip, forKey: "zip")
                managedObject.setValue(city.localizedCountryName, forKey: "localized_country_name")
                managedObject.setValue(city.center?.lat, forKey: "center_lat")
                managedObject.setValue(city.center?.lon, forKey: "center_lon")
                do {
                    try managedContext.save()
                    NotificationCenter.default.post(name: Notification.Name(rawValue: DEFAULT_CITY_CHANGED), object: nil)
                } catch let error as NSError {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        saveCityToHistory(city)
    }
    
    class func saveCityToHistory(_ city : City) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EverUsedCity")
        do {
            if let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                var managedObject : NSManagedObject?
                if results.count != 0 {
                    for savedCity : NSManagedObject in results {
                        var savedCityName = savedCity.value(forKey: "name") as! String?
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
                    let entity = NSEntityDescription.entity(forEntityName: "EverUsedCity", in: managedContext)
                    managedObject = NSManagedObject(entity: entity!, insertInto: managedContext)
                    managedObject!.setValue(city.name, forKey: "name")
                    managedObject!.setValue(city.state, forKey: "state")
                    managedObject!.setValue(city.zip, forKey: "zip")
                    managedObject!.setValue(city.localizedCountryName, forKey: "localized_country_name")
                    managedObject!.setValue(city.center?.lat, forKey: "center_lat")
                    managedObject!.setValue(city.center?.lon, forKey: "center_lon")
                }
                do {
                    managedObject?.setValue(Date().timeIntervalSince1970, forKey: "last_used_time")
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
    
    class func getEverUsedCities(_ count : Int) -> [City] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EverUsedCity")
        let sortDescriptor : NSSortDescriptor = NSSortDescriptor(key: "last_used_time", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        var everUsedCities = [City]()
        do {
            if let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                if results.count != 0 {
                    
                    for city : NSManagedObject in results {
                        if everUsedCities.count >= count {
                            break
                        }
                        let usedCity = City()
                        usedCity.name = city.value(forKey: "name") as? String
                        usedCity.state = city.value(forKey: "state") as? String
                        usedCity.zip = city.value(forKey: "zip") as? String
                        usedCity.localizedCountryName = city.value(forKey: "localized_country_name") as? String
                        let center = Location()
                        center.lat = city.value(forKey: "center_lat") as? Double
                        center.lon = city.value(forKey: "center_lon") as? Double
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
    
    class func getHotCities(_ count : Int) -> [City] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HotCity")
        var hotCities = [City]()
        do {
            if let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                if results.count != 0 {
                    
                    for city : NSManagedObject in results {
                        if hotCities.count >= count {
                            break
                        }
                        let hotCity = City()
                        hotCity.name = city.value(forKey: "name") as? String
                        hotCity.state = city.value(forKey: "state") as? String
                        hotCity.zip = city.value(forKey: "zip") as? String
                        hotCity.localizedCountryName = city.value(forKey: "localized_country_name") as? String
                        let center = Location()
                        center.lat = city.value(forKey: "center_lat") as? Double
                        center.lon = city.value(forKey: "center_lon") as? Double
                        hotCity.center = center
                        hotCities.append(hotCity)
                        
                    }
                } else {
                    hotCities.append(contentsOf: getDefaultHotCites())
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
    
    class func saveHotCities(_ hotCities : [City]) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HotCity")
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Could not delete all data in HotCity error : \(error) \(error.userInfo)")
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "HotCity", in: managedContext)
        for city in hotCities {
            let managedObject : NSManagedObject = NSManagedObject(entity: entity!, insertInto: managedContext)
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
    
    class func clearDataForEntity(_ entityName : String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            try managedContext.save()
        } catch let error as NSError {
            print("Could not delete all data in HotCity error : \(error) \(error.userInfo)")
        }
    }
}
