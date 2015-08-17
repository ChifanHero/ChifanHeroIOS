//
//  ModelProtocol.swift
//  SoHungry
//
//  Created by Shi Yan on 8/15/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

protocol Model {
    init(data : [String : AnyObject])
}

extension Model {
        
    init(){
        self.init()
    }
}