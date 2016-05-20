//
//  LocationHelper.swift
//  Lightning
//
//  Created by Shi Yan on 5/18/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import MapKit

class LocationHelper {
    
    class func getCityNameFromLocation(lat : Double, lon : Double, completionHandler: (String) -> Void) {
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
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                print(city)
                completionHandler(city as String)
            }
            
            
//            // Zip code
//            if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
//                print(zip)
//            }
//            
//            // Country
//            if let country = placeMark.addressDictionary!["Country"] as? NSString {
//                print(country)
//            }
        }
    }
}
