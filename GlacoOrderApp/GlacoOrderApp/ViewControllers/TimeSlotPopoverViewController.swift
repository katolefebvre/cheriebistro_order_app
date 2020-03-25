//
//  TimeSlotPopoverViewController.swift
//  GlacoOrderApp
//
//  Created by Parker Christie on 2020-03-25.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import UIKit

class TimeSlotPopoverViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var timeSlotTable: UITableView!
    var controllerDelegate : TimeSlotPopoverControllerDelegate?
    var timeSlotNames : [String] = []
    var timeSlotIds : [String] = []

    override func viewDidLoad() {
        getTimeSlots()
        super.viewDidLoad()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeSlotNames.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
                        self.timeSlotIds.append(ts["id"]! as! String)
                        self.timeSlotNames.append(ts["name"]! as! String)
                    }
                }
                
                DispatchQueue.main.async {
                    self.timeSlotTable.reloadData()
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell : DatabaseIdTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "timeSlot") as? DatabaseIdTableViewCell ?? DatabaseIdTableViewCell(style:UITableViewCell.CellStyle.default, reuseIdentifier: "timeSlot")
        
        let cellBackgroundView = UIView()
        cellBackgroundView.backgroundColor = .systemBlue
        
        tableCell?.textLabel?.font = UIFont.systemFont(ofSize: 25)
        tableCell?.textLabel?.text = timeSlotNames[indexPath.row]
        tableCell?.databaseId = (Int)(timeSlotIds[indexPath.row])
        tableCell?.selectedBackgroundView = cellBackgroundView
        
        return tableCell!
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (indexPath.row == controllerDelegate!.timeSlot - 1) {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath) as! DatabaseIdTableViewCell
        let selectedCellContent = selectedCell.databaseId
        
        controllerDelegate?.timeSlot = selectedCellContent!
    }

}
