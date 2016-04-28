//
//  Serializable.swift
//  Lightning
//
//  Created by Zhang, Alex on 4/27/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

protocol Serializable {
    func getProperties() -> [String : AnyObject]
}