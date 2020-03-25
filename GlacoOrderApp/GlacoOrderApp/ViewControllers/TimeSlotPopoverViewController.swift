//
//  TimeSlotPopoverViewController.swift
//  GlacoOrderApp
//
//  Created by Parker Christie on 2020-03-25.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import UIKit

class TimeSlotPopoverViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var controllerDelegate : TimeSlotPopoverControllerDelegate?
    var timeSlotNames : [String] = []
    var timeSlotIds : [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        timeSlotNames = ["Breakfast", "Lunch", "Dinner", "Drink"]
        timeSlotIds = [1, 2, 3, 4]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeSlotNames.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell : DatabaseIdTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "timeSlot") as? DatabaseIdTableViewCell ?? DatabaseIdTableViewCell(style:UITableViewCell.CellStyle.default, reuseIdentifier: "timeSlot")
        
        let cellBackgroundView = UIView()
        cellBackgroundView.backgroundColor = .systemBlue
        
        tableCell?.textLabel?.font = UIFont.systemFont(ofSize: 25)
        tableCell?.textLabel?.text = timeSlotNames[indexPath.row]
        tableCell?.databaseId = timeSlotIds[indexPath.row]
        tableCell?.selectedBackgroundView = cellBackgroundView
        
        return tableCell!
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let foundCell : DatabaseIdTableViewCell = cell as! DatabaseIdTableViewCell
        
        if (controllerDelegate?.timeSlots.contains(foundCell.databaseId!))! {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath) as! DatabaseIdTableViewCell
        let selectedCellContent = selectedCell.databaseId
        
        if !(controllerDelegate?.timeSlots.contains(selectedCellContent!))! {
            controllerDelegate?.addTimeSlot(timeSlotId: selectedCellContent!)
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath) as! DatabaseIdTableViewCell
        let selectedCellContent = selectedCell.databaseId
        
        if (controllerDelegate?.timeSlots.contains(selectedCellContent!))! {
            controllerDelegate?.removeTimeSlot(timeSlotId: selectedCellContent!)
        }
        
    }

}
