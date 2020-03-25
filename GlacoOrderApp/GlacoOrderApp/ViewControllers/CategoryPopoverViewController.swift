//
//  CategoryPopoverViewController.swift
//  GlacoOrderApp
//
//  Created by Parker Christie on 2020-03-11.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import UIKit

class CategoryPopoverViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var controllerDelegate : CategoryPopoverControllerDelegate?
    var timeslotIDs : [String] = []
    var timeslotNames : [String] = []
    
    @IBOutlet var tableView : UITableView!

    override func viewDidLoad() {
        getTimeSlots()
        super.viewDidLoad()
    }
    
    func getTimeSlots() {
        let url = URL(string: "http://142.55.32.86:50131/cheriebistro/api/gettimeslots.php")!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        
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
                    if let ts = timeslot as? [String: Any] {
                        self.timeslotIDs.append(ts["id"]! as! String)
                        self.timeslotNames.append(ts["name"]! as! String)
                    }
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeslotIDs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell : DatabaseIdTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "time_slot") as? DatabaseIdTableViewCell ?? DatabaseIdTableViewCell(style:UITableViewCell.CellStyle.default, reuseIdentifier: "time_slot")
        
        let cellBackgroundView = UIView()
        cellBackgroundView.backgroundColor = .systemBlue
        
        tableCell?.textLabel?.font = UIFont.systemFont(ofSize: 24)
        tableCell?.textLabel?.text = timeslotNames[indexPath.row]
        tableCell?.databaseId = Int(timeslotIDs[indexPath.row])
        tableCell?.selectedBackgroundView = cellBackgroundView
        
        return tableCell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let foundCell : DatabaseIdTableViewCell = cell as! DatabaseIdTableViewCell
        
        if (controllerDelegate?.categories.contains(foundCell.databaseId!))! {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath) as! DatabaseIdTableViewCell
        let selectedCellContent = selectedCell.databaseId
        
        if !(controllerDelegate?.categories.contains(selectedCellContent!))! {
            controllerDelegate?.addCategory(categoryId: selectedCellContent!)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath) as! DatabaseIdTableViewCell
        let selectedCellContent = selectedCell.databaseId
        
        if (controllerDelegate?.categories.contains(selectedCellContent!))! {
            controllerDelegate?.removeCategory(categoryId: selectedCellContent!)
        }
        
    }
}
