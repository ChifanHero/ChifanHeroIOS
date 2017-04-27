//
//  ParseConfiguration.swift
//  ChifanHero
//
//  Created by Shi Yan on 8/17/15.
//  Copyright © 2015 ChifanHero. All rights reserved.
//

import Foundation


class ParseConfiguration: ServiceConfiguration {
    
    func hostEndpoint() -> String {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "usingStaging") {
            return "http://chifanhero-staging.us-east-1.elasticbeanstalk.com/parse"
        } else {
            return "http://chifanhero.us-east-1.elasticbeanstalk.com/parse"
        }
        
    }
}
