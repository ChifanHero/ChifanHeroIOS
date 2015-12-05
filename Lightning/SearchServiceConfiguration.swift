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
        return "http://internal.lightningorder.com"
    }
}