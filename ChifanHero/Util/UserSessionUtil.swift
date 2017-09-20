//
//  UserContext.swift
//  Lightning
//
//  Created by Shi Yan on 12/5/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class UserSessionUtil {
    
    class func deleteSessionToken() {
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: "sessionToken")
    }
    
    class func isValidUser() -> Bool {
        let defaults = UserDefaults.standard
        let sessionToken = defaults.string(forKey: "sessionToken")
        return sessionToken != nil
    }
}
