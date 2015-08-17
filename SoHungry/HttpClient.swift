//
//  HttpClient.swift
//  SoHungry
//
//  Created by Shi Yan on 8/15/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class HttpClient {
    
    static let contentTypeHeader = "Content-Type"
    static let acceptHeader = "Accept"
    static let applicationJson = "application/json"
    
    var headers = [String : String]()
    
    init() {
        setDefaultHeaders()
    }
    
    func post(url:String, headers:[String : String]?, parameters : [String : AnyObject], completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
        let request = NSMutableURLRequest(URL:NSURL(string: url)!)
        request.HTTPMethod = "POST"
        if headers != nil {
            for (header, value) in headers! {
                if self.headers[header] != value {
                    self.headers[header] = value
                }
            }
        }
        for (header, value) in self.headers {
            request.addValue(value, forHTTPHeaderField: header)
        }
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(parameters, options: NSJSONWritingOptions.PrettyPrinted)
        } catch {
            print(error)
        }
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            completionHandler(data, response, error)
        }
        task.resume()
    }
    
    func get(url:String, headers:[String : String]?, parameters : [String : AnyObject], completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
        let request = NSMutableURLRequest(URL:NSURL(string: url)!)
        request.HTTPMethod = "GET"
        if headers != nil {
            for (header, value) in headers! {
                if self.headers[header] != value {
                    self.headers[header] = value
                }
            }
        }
        for (header, value) in self.headers {
            request.addValue(value, forHTTPHeaderField: header)
        }
        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { (data, response, error) -> Void in
            completionHandler(data, response, error)
        }
        task.resume()
    }
    
    private func setDefaultHeaders() {
        headers[HttpClient.contentTypeHeader] = HttpClient.applicationJson
        headers[HttpClient.acceptHeader] = HttpClient.applicationJson
    }
}
