//
//  File.swift
//  Lightning
//
//  Created by Zhang, Alex on 6/1/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class HttpRequest: HttpRequestProtocol{
    
    var headers = Dictionary<String, String>()
    
    init(){
        self.headers["Content-Type"] = "application/json"
        self.headers["Accept"] = "application/json"
    }
    
    func getRelativeURL() -> String{
        return ""
    }
    
    func getRequestBody() -> [String : AnyObject] {
        let parameters = Dictionary<String, String>()
        return parameters
    }
    
    func getHeaders() -> [String : String] {
        return self.headers
    }
    
    func addHeader(key key: String, value: String) -> Void{
        self.headers[key] = value
    }
}