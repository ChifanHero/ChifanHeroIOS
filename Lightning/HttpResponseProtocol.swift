//
//  HttpResponseProtocol.swift
//  Lightning
//
//  Created by Zhang, Alex on 5/31/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

protocol HttpResponseProtocol {
    init(data : [String : AnyObject])
    init()
}