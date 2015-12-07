//
//  PostRequestProtocol.swift
//  Lightning
//
//  Created by Shi Yan on 8/15/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

protocol PostRequestProtocol: HttpRequestProtocol{
    func getRequestBody() -> [String : AnyObject]
}
