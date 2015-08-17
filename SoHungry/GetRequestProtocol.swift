//
//  GetRequestProtocol.swift
//  SoHungry
//
//  Created by Shi Yan on 8/15/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

protocol GetRequestProtocol {
    func getParameters() -> [String:String]
}

protocol GetResourceRequestProtocol {
    func getResourceId() -> String
}
