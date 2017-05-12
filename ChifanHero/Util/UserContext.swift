//
//  UserContext.swift
//  Lightning
//
//  Created by Shi Yan on 12/5/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class UserContext {
    
    static let RATE_MINUTES_INTERVAL = 10
    
    static let instance = UserContext()
    
    var userLocation = Location()
    
    func getUserLocation() -> Location{
        return userLocation
    }
    
    class func isRatingTooFrequent(_ objectId : String) -> Bool{
        let defaults = UserDefaults.standard
        let now : Int = Int(Date().timeIntervalSince1970 * 1000)
        let lastRateTime = defaults.integer(forKey: objectId)
        if (now - lastRateTime < UserContext.RATE_MINUTES_INTERVAL * 60 * 60) {
            return true
        } else {
            return false
        }
    }
    
    class func isValidUser() -> Bool {
        let defaults = UserDefaults.standard
        let sessionToken = defaults.string(forKey: "sessionToken")
        return sessionToken != nil
    }
}
