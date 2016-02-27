//
//  DeleteRequestProtocol.swift
//  Lightning
//
//  Created by Zhang, Alex on 2/27/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

protocol DeleteRequestProtocol: HttpRequestProtocol{
    func getRequestBody() -> [String : AnyObject]
}