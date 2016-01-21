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
    
    static func isRatingTooFrequent(objectId : String) -> Bool{
        let defaults = NSUserDefaults.standardUserDefaults()
        let now : Int = Int(NSDate().timeIntervalSince1970 * 1000)
        let lastRateTime = defaults.integerForKey(objectId)
        if (now - lastRateTime < UserContext.RATE_MINUTES_INTERVAL * 60 * 60) {
            return true
        } else {
            return false
        }
    }
    
    static func isValidUser() -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        let sessionToken = defaults.stringForKey("sessionToken")
        return sessionToken != nil
    }
    
}
