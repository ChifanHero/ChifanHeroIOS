//
//  UserContext.swift
//  Lightning
//
//  Created by Shi Yan on 12/5/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class UserContext {
    
    static let instance = UserContext()
    
    var userLocation = Location()
    
    func getUserLocation() -> Location{
        return userLocation
    }
}
