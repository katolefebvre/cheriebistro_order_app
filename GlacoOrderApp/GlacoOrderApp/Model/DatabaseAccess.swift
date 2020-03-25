//
//  DatabaseAccess.swift
//  GlacoOrderApp
//
//  Created by Kato Lefebvre on 2020-03-25.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import Foundation

class DatabaseAccess {
    
    class func getTimeSlots() -> [TimeSlot] {
        var results : [TimeSlot] = []
        let url = URL(string: "http://142.55.32.86:50131/cheriebistro/api/gettimeslots.php")!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error")
                return
            }
            
            do {
                var timeslotJSON : NSDictionary!
                timeslotJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                let timeslotArray : NSArray = timeslotJSON["time_slots"] as! NSArray
                
                for timeslot in timeslotArray {
                    if let ts = timeslot as? [String : Any] {
                        results.append(TimeSlot(id: Int(ts["id"]! as! String)!, name: ts["name"]! as! String))
                    }
                }
            } catch {
                print(error)
            }
            semaphore.signal()
        }
        
        task.resume()
        _ = semaphore.wait(wallTimeout: .distantFuture)
        return results
    }
    
    class func getCategories() -> [Category] {
        var results : [Category] = []
        let url = URL(string: "http://142.55.32.86:50131/cheriebistro/api/getcategories.php")!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error")
                return
            }
            
            do {
                var categoryJSON : NSDictionary!
                categoryJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                let categoryArray : NSArray = categoryJSON["categories"] as! NSArray
                
                for category in categoryArray {
                    if let c = category as? [String : Any] {
                        results.append(Category(id: Int(c["id"]! as! String)!, name: c["name"]! as! String))
                    }
                }
            } catch {
                print(error)
            }
            semaphore.signal()
        }
        
        task.resume()
        _ = semaphore.wait(wallTimeout: .distantFuture)
        return results
    }
}
