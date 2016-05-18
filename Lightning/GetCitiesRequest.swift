//
//  GetCitiesRequest.swift
//  Lightning
//
//  Created by Shi Yan on 5/17/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class GetCitiesRequest : GetRequestProtocol {
    
    var prefix : String = ""

    func getRelativeURL() -> String {
        return "/cities?prefix=" + prefix.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
    }
}
