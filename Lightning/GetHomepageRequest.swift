//
//  GetHomepageRequest.swift
//  Lightning
//
//  Created by Zhang, Alex on 8/1/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class GetHomepageRequest: HttpRequest{
    
    override init() {
    }
    
    override func getRelativeURL() -> String {
        return "/homepage"
    }
}