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
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "usingStaging") {
            return "http://Custom-env-2.zwjspztzpv.us-east-1.elasticbeanstalk.com/parse"
        } else {
            return "http://chifanhero.us-east-1.elasticbeanstalk.com/parse"
        }
        
    }
}
