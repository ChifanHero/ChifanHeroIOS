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
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "usingStaging") {
            self.headers["X-Parse-Application-Id"] = "28BX7btLUKGGsFGCSyGGv9Pzj1nCWDl9EV6GpMBQ"
            self.headers["X-Parse-Master-Key"] = "rj0pEKLhfWX8310qDj9s0rUEAo4ukQJrTNtCP11j"
        } else {
            self.headers["X-Parse-Application-Id"] = "Z6ND8ho1yR4aY3NSq1zNNU0kPc0GDOD1UZJ5rgxM"
            self.headers["X-Parse-Master-Key"] = "KheL2NaRmyVKr11LZ7yC0uvMHxNv8RpX389oUf8F"
        }
    }
    
    func getRelativeURL() -> String{
        return ""
    }
    
    func getRequestBody() -> [String : AnyObject] {
        let parameters = Dictionary<String, String>()
        return parameters as [String : AnyObject]
    }
    
    func getHeaders() -> [String : String] {
        return self.headers
    }
    
    func addHeader(key: String, value: String) -> Void{
        self.headers[key] = value
    }
}
