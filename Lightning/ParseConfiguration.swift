//
//  ParseConfiguration.swift
//  Lightning
//
//  Created by Shi Yan on 8/17/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation


class ParseConfiguration: ServiceConfiguration {
    
    func hostEndpoint() -> String {
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.boolForKey("usingStaging") {
            return "http://staging.internal.service.lightningorder.com"
        } else {
            return "http://internal.service.lightningorder.com"
        }
        
    }
}
