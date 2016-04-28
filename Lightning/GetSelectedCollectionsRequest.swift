//
//  GetSelectedCollectionsRequest.swift
//  Lightning
//
//  Created by Zhang, Alex on 4/27/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class GetSelectedCollectionsRequest: GetRequestProtocol{
    
    
    init(){
    }
    
    func getParameters() -> [String:String] {
        let parameters = Dictionary<String, String>()
        return parameters
    }
    
    func getRelativeURL() -> String {
        return "/favorites?type="
    }
}