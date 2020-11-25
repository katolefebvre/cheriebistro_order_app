//
//  ManageTableAssignmentsViewController.swift
//  GlacoOrderApp
//
//  Created by Parker Christie on 2020-11-25.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import UIKit

class ManageTableAssignmentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var assignedTables : [Table] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignedTables.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "assignedTableCell");
        let index = indexPath.row
        
        tableCell?.textLabel?.text = "Table \(assignedTables[index].id) : Employee \(assignedTables[index].employeeId)"
        
        return tableCell!
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
