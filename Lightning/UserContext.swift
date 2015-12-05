//
//  UserContext.swift
//  Lightning
//
//  Created by Shi Yan on 12/5/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class UserContext {
    
    class func getUserLocation() -> (Double, Double){
        let lat = 37.29545969999999
        let lon = -121.92755119999998
        return (lat, lon)
    }
}
