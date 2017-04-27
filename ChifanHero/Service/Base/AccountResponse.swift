//
//  AccountResponse.swift
//  Lightning
//
//  Created by Zhang, Alex on 6/22/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class AccountResponse: HttpResponseProtocol{
    var success: Bool?
    var sessionToken: String?
    var user: User?
    var error: Error?
    
    required init() {}
    
    required init(data: JSON) {}
}
