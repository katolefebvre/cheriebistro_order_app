//
//  EmployeePopoverViewController.swift
//  GlacoOrderApp
//
//  Created by Parker Christie on 2020-09-23.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import UIKit

/// ViewController for the CategoryPopover
class EmployeePopoverViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    /// The current CategoryPopoverDelegate
    var controllerDelegate : EmployeePopoverControllerDelegate?
    var employees : [Employee] = []
    var validToModifyEmployees : [Employee] = []
    @IBOutlet var employeeTable : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.employees = DatabaseAccess.getEmployees()
        for employee in employees {
            if employee.id != mainDelegate.loggedEmployee!.id && employee.role.id > mainDelegate.loggedEmployee!.role.id {
                validToModifyEmployees.append(employee)
            }
        }
        
        DispatchQueue.main.async {
            self.employeeTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return validToModifyEmployees.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell : DatabaseIdTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "employee") as? DatabaseIdTableViewCell ?? DatabaseIdTableViewCell(style:UITableViewCell.CellStyle.default, reuseIdentifier: "employee")
        
        let cellBackgroundView = UIView()
        cellBackgroundView.backgroundColor = .systemBlue
        
        tableCell?.textLabel?.font = UIFont.systemFont(ofSize: 24)
        tableCell?.textLabel?.text = validToModifyEmployees[indexPath.row].name
        tableCell?.databaseId = (Int)(validToModifyEmployees[indexPath.row].id)
        tableCell?.selectedBackgroundView = cellBackgroundView
        
        return tableCell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let displayCell = cell as! DatabaseIdTableViewCell
        if (controllerDelegate?.getEmployee() != nil) {
            if (String(displayCell.databaseId!) == (controllerDelegate!.getEmployee()?.id)!) {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath) as! DatabaseIdTableViewCell
        let selectedCellContent = selectedCell.databaseId!
        
        controllerDelegate?.setEmployee(employee: validToModifyEmployees.first(where: {$0.id == String(selectedCellContent)})!)
    }
}
