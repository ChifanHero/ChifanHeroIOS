//
//  Queue.swift
//  Lightning
//
//  Created by Shi Yan on 8/18/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class Queue {
    
    static let MainQueue = MainQueueDelegate()
    
}

protocol QueueDelegate {
    
    func perform (closure:() -> ()) -> Void
    
}

class MainQueueDelegate : QueueDelegate {
    
    func perform (closure:() -> Void) -> Void {
        dispatch_async(dispatch_get_main_queue(), {
            closure()
        });
        
    }

}
