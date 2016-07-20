//
//  GetImagesRequest.swift
//  Lightning
//
//  Created by Zhang, Alex on 7/20/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class GetImagesRequest: HttpRequest {
    
    var restaurantId: String
    
    init(restaurantId: String) {
        self.restaurantId = restaurantId
    }
    
    override func getRelativeURL() -> String {
        return "/images?restaurantId=" + restaurantId
    }
}