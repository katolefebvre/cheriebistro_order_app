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
    
    /// The current CategoryPopoverDelegate
    var controllerDelegate : EmployeePopoverControllerDelegate?
    var employees : [Employee] = []
    @IBOutlet var categoryTable : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.employees = DatabaseAccess.getEmployees()
        
        DispatchQueue.main.async {
            self.categoryTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell : DatabaseIdTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "category") as? DatabaseIdTableViewCell ?? DatabaseIdTableViewCell(style:UITableViewCell.CellStyle.default, reuseIdentifier: "category")
        
        let cellBackgroundView = UIView()
        cellBackgroundView.backgroundColor = .systemBlue
        
        tableCell?.textLabel?.font = UIFont.systemFont(ofSize: 24)
        tableCell?.textLabel?.text = employees[indexPath.row].name
        tableCell?.databaseId = (Int)(employees[indexPath.row].id)
        tableCell?.selectedBackgroundView = cellBackgroundView
        
        return tableCell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let foundCell : DatabaseIdTableViewCell = cell as! DatabaseIdTableViewCell
        
        if (controllerDelegate?.getEmployees().contains(where: {$0.id == String(foundCell.databaseId!)}))! {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath) as! DatabaseIdTableViewCell
        let selectedCellContent = selectedCell.databaseId
        
        if !(controllerDelegate?.getEmployees().contains(where: {$0.id == String(selectedCellContent!)}))! {
            controllerDelegate?.setEditEmployee(employee: Employee(id : String(selectedCellContent!), name: selectedCell.textLabel!.text!, roleID: "1"))
        }
    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//
//        let selectedCell = tableView.cellForRow(at: indexPath) as! DatabaseIdTableViewCell
//        let selectedCellContent = selectedCell.databaseId
//
//        if (controllerDelegate?.getCategories().contains(where: {$0.id == selectedCellContent}))! {
//            controllerDelegate?.removeCategory(category: Category(id : selectedCellContent!, name: selectedCell.textLabel!.text!))
//        }
//
//    }
}
