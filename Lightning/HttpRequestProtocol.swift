//
//  HttpRequestProtocol.swift
//  Lightning
//
//  Created by Shi Yan on 8/17/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation


protocol HttpRequestProtocol {    
    func getRelativeURL() -> String
    func getRequestBody() -> [String : AnyObject]
}