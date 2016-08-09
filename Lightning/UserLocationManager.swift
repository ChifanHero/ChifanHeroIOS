//
//  CityCache.swift
//  Lightning
//
//  Created by Shi Yan on 8/8/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

/**
    This class is for caching the user city. Whenever the user select a custom city as his/her location, the information of that city will be stored here as well as in coredata. If app is relaunched, this cache will be empty. In that case, it will load the most recently used city from coredata and cache it.
 */
class UserLocationManager {
    
    private var realtimeLocation : Location?
    private var cityInUse : City?
    
    func getLocationInUse() -> Location? {
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.boolForKey("usingCustomLocation") {
            let city = getCityInUse()
            return city?.center
        } else {
            return realtimeLocation
        }
        
    }
    
    func saveRealtimeLocation(location : Location) {
        realtimeLocation = location
    }
    
    func getCityInUse() -> City? {
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.boolForKey("usingCustomLocation") {
            if cityInUse == nil {
                let cityFromCoreData : City? = LocationHelper.getDefaultCityFromCoreData()
                if cityFromCoreData != nil {
                    cityInUse = cityFromCoreData!
                } else {
                    cityInUse = LocationHelper.getDefaultCity()
                }
            }
            return cityInUse!
        } else {
            return nil
        }
        
    }
    
    func saveCityInUse(city : City) {
        cityInUse = city
        LocationHelper.saveDefaultCityToCoreData(city)
        LocationHelper.saveCityToHistory(city)
    }
    
}
