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
    var timeSlots : [TimeSlot] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.timeSlots = DatabaseAccess.getTimeSlots()
        
        DispatchQueue.main.async {
            self.timeSlotTable.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeSlots.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell : DatabaseIdTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "timeSlot") as? DatabaseIdTableViewCell ?? DatabaseIdTableViewCell(style:UITableViewCell.CellStyle.default, reuseIdentifier: "timeSlot")
        
        let cellBackgroundView = UIView()
        cellBackgroundView.backgroundColor = .systemBlue
        
        tableCell?.textLabel?.font = UIFont.systemFont(ofSize: 25)
        tableCell?.textLabel?.text = timeSlots[indexPath.row].name
        tableCell?.databaseId = timeSlots[indexPath.row].id
        tableCell?.selectedBackgroundView = cellBackgroundView
        
        return tableCell!
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let displayCell = cell as! DatabaseIdTableViewCell
        if (controllerDelegate?.getTimeSlot() != nil) {
            if (displayCell.databaseId == (controllerDelegate!.getTimeSlot()?.id)!) {
                           tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                   }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath) as! DatabaseIdTableViewCell
        let selectedCellContent = selectedCell.databaseId
        
        controllerDelegate?.setTimeSlot(timeSlot: timeSlots.first(where: { $0.id == selectedCellContent})!)
    }

}
