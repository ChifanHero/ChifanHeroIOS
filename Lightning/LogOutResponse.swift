//
//  LogOutResponse.swift
//  Lightning
//
//  Created by Zhang, Alex on 11/25/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class LogOutResponse: AccountResponse{
    
    required init() {
        super.init()
    }
    
    required init(data: JSON) {
        super.init()
        error = Error(data: data["error"])
        success = data["success"].bool
    }
}
