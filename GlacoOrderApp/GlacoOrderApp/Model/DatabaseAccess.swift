//
//  DatabaseAccess.swift
//  GlacoOrderApp
//
//  Created by Kato Lefebvre on 2020-03-25.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import Foundation
import UIKit

/// Represents the connection between the application and the PHP API.
class DatabaseAccess {
    
    let mainDelegate = UIApplication.shared.delegate
    
    /// Retrieves all of the TimeSlots stored in the database and returns them.
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
    
    /// Retrieves all of the Categories stored in the database and returns them.
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
    
    
    /// Retrieves all of the MenuItems stored in the database and returns them.
    class func getMenuItems() -> [MenuItem] {
        var results: [MenuItem] = []
        let url = URL(string: "http://142.55.32.86:50131/cheriebistro/api/getmenuitems.php")!
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
                var menuitemJSON : NSDictionary!
                menuitemJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                let menuitemArray : NSArray = menuitemJSON["menu_items"] as! NSArray
                
                for menuitem in menuitemArray {
                    if let mi = menuitem as? [String : Any] {
                        results.append(MenuItem(
                            id: Int(mi["id"]! as! String)!,
                            name: mi["name"]! as! String,
                            description: mi["description"]! as! String,
                            price: Float(mi["price"]! as! String)!,
                            timeslot: TimeSlot(
                                id: Int(mi["time_slot_id"]! as! String)!,
                                name: "Sunrise Breakfast" // hard coded for now
                            )
                        ))
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
    
    
    /// Sends a request to add a MenuItem to the database
    /// - Parameters:
    ///   - name: Name of the MenuItem.
    ///   - description: Description of the MenuItem.
    ///   - timeslotID: Selected TimeSlot ID of the MenuItem.
    ///   - price: Price of the MenuItem.
    ///   - categoryIds: List of category IDs of the MenuItem.
    class func addMenuItem(name: String, description: String, timeslotID: Int, price: String, categoryIds : [Int]) -> [String : String] {
        var responseArray : [String : String] = [:]
        
        let address = URL(string: "http://142.55.32.86:50131/cheriebistro/api/addfooditem.php")!
        let url = NSMutableURLRequest(url: address)
        url.httpMethod = "POST"
        let semaphore = DispatchSemaphore(value: 0)
        
        var dataString = "name=\(name)"
        dataString = dataString + "&description=\(description)"
        dataString = dataString + "&time_slot_id=\(timeslotID)"
        dataString = dataString + "&price=\(price)"
        
        let stringCategoryIds = categoryIds.map {String($0)}
        let serializedCategoryIds = stringCategoryIds.joined(separator: ",")
        dataString = dataString + "&category_ids=\(serializedCategoryIds)"
        
        let dataD = dataString.data(using: .utf8)
        
        do {
            let uploadJob = URLSession.shared.uploadTask(with: url as URLRequest, from: dataD) {
                data, response, error in
                if error != nil {
                    print(error!)
                    return
                } else {
                    if let unwrappedData = data {
                        let jsonResponse = try! JSONSerialization.jsonObject(with: unwrappedData, options: [])
                        guard let jsonArray = jsonResponse as? [String: String] else {
                            return
                        }

                        if jsonArray["error"] == "false" {
                            responseArray = jsonArray
                        } else {
                            responseArray["error"] = "Menu item failed to upload."
                        }
                    }
                }
                semaphore.signal()
            }
            uploadJob.resume()
        }
        
        _ = semaphore.wait(wallTimeout: .distantFuture)
        return responseArray
    }
    
    
    /// Sends a request to add a category to the database
    /// - Parameter name: name of the category
    class func addCategory(name: String)-> [String : String]{
        
        var responseArray : [String : String] = [:]
        
        let address = URL(string: "http://142.55.32.86:50131/cheriebistro/api/addCategory.php")!
        let url = NSMutableURLRequest(url: address)
        url.httpMethod = "POST"
        let semaphore = DispatchSemaphore(value: 0)
        
        let dataString = "name=\(name)"
        
        let dataD = dataString.data(using: .utf8)
        
        do {
            let uploadJob = URLSession.shared.uploadTask(with: url as URLRequest, from: dataD) {
                data, response, error in
                if error != nil {
                    print(error!)
                    return
                } else {
                    //print(data ?? "No Data")
                    if let unwrappedData = data {
                        let jsonResponse = try! JSONSerialization.jsonObject(with: unwrappedData, options: [])
                        guard let jsonArray = jsonResponse as? [String: String] else {
                            return
                        }
                        if jsonArray["error"] == "false" {
                            responseArray = jsonArray
                        } else {
                            responseArray["error"] = "Category failed to upload."
                        }
                    }
                }
                semaphore.signal()
            }
            uploadJob.resume()
        }
        _ = semaphore.wait(wallTimeout: .distantFuture)
        return responseArray
    }
    
    class func loginEmployee(loginId : String) -> Employee? {
        
        var employee : Employee?
        let myUrl = URL(string: "http://142.55.32.86:50131/cheriebistro/api/loginUser.php")!
        let request = NSMutableURLRequest(url: myUrl)
        request.httpMethod = "POST"
        let semaphore = DispatchSemaphore(value: 0)

        let postString = "employeeID=\(loginId)"
        request.httpBody = postString.data(using: String.Encoding.utf8)

        let task = URLSession.shared.dataTask(with: request as URLRequest) {
        data, response, error in
            if error != nil
            {
                print("error")
                semaphore.signal()
                return
            }
            do
            {
                var LoginJSON : NSDictionary!
                LoginJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
            
                if let parseJSON = LoginJSON {
                    let response:String = parseJSON["status"] as! String;
                    print("result: \(response)")

                    if(response == "Success")
                    {
                        
                        let employeeId : String = LoginJSON["employeeID"] as! String
                        let employeeName : String = LoginJSON["employeeName"] as! String
                        
                        employee = Employee(id: employeeId, name: employeeName)
                    }
                    else{
                    }
                }
            }
            catch
            {
                print(error)
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(wallTimeout: .distantFuture)
        return employee
    }
}
