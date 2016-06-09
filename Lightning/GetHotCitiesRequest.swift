//
//  GetHotCitiesRequest.swift
//  Lightning
//
//  Created by Shi Yan on 5/27/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class GetHotCitiesRequest: HttpRequest {
    
    override func getRelativeURL() -> String {
        return "/hotCities" 
    }
}