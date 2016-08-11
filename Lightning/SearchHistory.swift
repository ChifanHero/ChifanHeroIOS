//
//  SearchHistory.swift
//  Lightning
//
//  Created by Shi Yan on 8/6/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import CoreData

class SearchHistory {
    
    static func saveKeyword(keyword : String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("SearchHistory", inManagedObjectContext: managedContext)
        let fetchRequest = NSFetchRequest(entityName: "SearchHistory")
        do {
            var keywordObject : NSManagedObject?
            if let results = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                if results.count != 0 {
                    for savedKeyword : NSManagedObject in results {
                        var savedKeywordValue = savedKeyword.valueForKey("keyword") as! String?
                        if savedKeywordValue == nil {
                            savedKeywordValue = ""
                        }
                        if savedKeywordValue == keyword {
                            keywordObject = savedKeyword
                            break
                        }
                    }
                }
            }
            if (keywordObject == nil) {
                keywordObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                keywordObject!.setValue(keyword, forKey: "keyword")
            }
            keywordObject!.setValue(NSDate().timeIntervalSince1970, forKey: "last_used_time")
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    static func saveAddress(address : String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("SearchAddressHistory", inManagedObjectContext: managedContext)
        let fetchRequest = NSFetchRequest(entityName: "SearchAddressHistory")
        do {
            var addressObject : NSManagedObject?
            if let results = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                if results.count != 0 {
                    for savedAddress : NSManagedObject in results {
                        var savedAddressValue = savedAddress.valueForKey("address") as! String?
                        if savedAddressValue == nil {
                            savedAddressValue = ""
                        }
                        if savedAddressValue == address {
                            addressObject = savedAddress
                            break
                        }
                    }
                }
            }
            if (addressObject == nil) {
                addressObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                addressObject!.setValue(address, forKey: "address")
            }
            addressObject!.setValue(NSDate().timeIntervalSince1970, forKey: "last_used_time")
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    static func removeKeywordFromHistory (keyword : String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "SearchHistory")
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            if let results = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                if results.count != 0 {
                    for result : NSManagedObject in results {
                        if let resultValue = result.valueForKey("keyword") as? String {
                            if resultValue == keyword {
                                managedContext.deleteObject(result)
                            }
                        }
                    }
                }
            }
            try managedContext.save()
        } catch let error as NSError {
            print("Could not delete keyword. error : \(error) \(error.userInfo)")
        }
        
    }
    
    static func removeAddressFromHistory (address : String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "SearchAddressHistory")
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            if let results = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                if results.count != 0 {
                    for result : NSManagedObject in results {
                        if let resultValue = result.valueForKey("address") as? String {
                            if resultValue == address {
                                managedContext.deleteObject(result)
                            }
                        }
                    }
                }
            }
            try managedContext.save()
        } catch let error as NSError {
            print("Could not delete address. error : \(error) \(error.userInfo)")
        }
        
    }
    
    static func getRecentKeywords (count : Int) -> [String]{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "SearchHistory")
        let sortDescriptor : NSSortDescriptor = NSSortDescriptor(key: "last_used_time", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        var keywords = [String]()
        do {
            if let results : [NSManagedObject] = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                if results.count != 0 {
                    for result : NSManagedObject in results {
                        if (keywords.count >= count) {
                            break
                        }
                        if let value = result.valueForKey("keyword") as? String {
                            keywords.append(value)
                        }
                        
                    }
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return keywords
    }
    
    static func getRecentAddress (count : Int) -> [String]{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "SearchAddressHistory")
        let sortDescriptor : NSSortDescriptor = NSSortDescriptor(key: "last_used_time", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        var addresses = [String]()
        do {
            if let results : [NSManagedObject] = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                if results.count != 0 {
                    for result : NSManagedObject in results {
                        if (addresses.count >= count) {
                            break
                        }
                        if let value = result.valueForKey("address") as? String {
                            addresses.append(value)
                        }
                        
                    }
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return addresses
        
    }

    
    
}
