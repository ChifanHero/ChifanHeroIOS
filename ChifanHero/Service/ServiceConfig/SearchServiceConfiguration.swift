//
//  SearchServiceConfiguration.swift
//  Lightning
//
//  Created by Shi Yan on 12/5/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class SearchServiceConfiguration: ServiceConfiguration {
    
    func hostEndpoint() -> String {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "usingStaging") {
//            return "http://10.0.1.19:8080"
            return "http://staging-aggregateapi-chifanhero.us-west-2.elasticbeanstalk.com"
        } else {
            return "https://search.chifanhero.com"
        }
    }
}
