//
//  UpdateRequestProtocol.swift
//  Lightning
//
//  Created by Shi Yan on 4/8/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

protocol UpdateRequestProtocol: HttpRequestProtocol{
    func getRequestBody() -> [String : AnyObject]
}