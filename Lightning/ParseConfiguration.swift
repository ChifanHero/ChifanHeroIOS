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
            return "Custom-env-2.zwjspztzpv.us-east-1.elasticbeanstalk.com"
        } else {
            return "chifanhero.us-east-1.elasticbeanstalk.com"
        }
        
    }
}
