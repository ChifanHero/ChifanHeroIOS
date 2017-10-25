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
            return "http://10.0.1.19:1337/parse"
            //return "http://localhost:1337/parse"
        } else {
            return "https://chifanhero.com/parse"
        }
        
    }
}
