//
//  ManageTableAssignmentsViewController.swift
//  GlacoOrderApp
//
//  Created by Parker Christie on 2020-11-25.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import UIKit

class ManageTableAssignmentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var assignedTableView: UITableView!
    private var assignedTables : [Table] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignedTables.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "assignedTableCell") ?? UITableViewCell()
        let index = indexPath.row
        
        tableCell.textLabel?.text = "Table \(assignedTables[index].id) : Employee \(assignedTables[index].employeeId)"
        
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let index = indexPath.row
        var swipeActions = UISwipeActionsConfiguration(actions: [])
        let unassign = UIContextualAction(style: .destructive, title: "Unassign") { (action, view, bool)  in
            let deleteAlert = UIAlertController(title: "Unassign this table?", message: "Are you sure you want to unassign this table? This cannot be undone.", preferredStyle: .alert)
            deleteAlert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
                if DatabaseAccess.unassignTable(tableID: self.assignedTables[index].id) {
                    self.assignedTables = DatabaseAccess.getAssignedTables()
                    self.assignedTableView.reloadData()
                    let successAlert = UIAlertController(title: "Success", message: "The table has successfully been unassigned.", preferredStyle: .alert)
                    successAlert.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self.present(successAlert, animated: true, completion: nil)
                } else {
                    let errorAlert = UIAlertController(title: "ERROR", message: "An error occurred, this order item was not properly deleted.", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(errorAlert, animated: true, completion: nil)
                }
            })
            
            deleteAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self.present(deleteAlert, animated: true, completion: nil)
        }
        
        swipeActions = UISwipeActionsConfiguration(actions: [unassign])
        return swipeActions
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        assignedTables = DatabaseAccess.getAssignedTables()
        assignedTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
