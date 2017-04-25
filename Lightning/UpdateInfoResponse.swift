//
//  UpdateInfoResponse.swift
//  Lightning
//
//  Created by Zhang, Alex on 11/23/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class UpdateInfoResponse: AccountResponse{
    
    required init() {
        super.init()
    }
    
    required init(data: JSON) {
        super.init(data: data)
        error = Error(data: data["error"])
        user = User(data: data["user"])
        success = data["success"].bool
    }
}
