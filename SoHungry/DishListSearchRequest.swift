//
//  DishListSearchRequest.swift
//  SoHungry
//
//  Created by Shi Yan on 12/2/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class DishListSearchRequest : PostRequestProtocol{
    
    var keyword : String?
    var offset : Int?
    var limit : Int?
    var sortBy : String?
    var sortOrder : String?
    
    func getRequestBody() -> [String : AnyObject] {
        
    }
    
}
