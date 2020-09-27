//
//  RolePopoverViewController.swift
//  GlacoOrderApp
//
//  Created by Parker Christie on 2020-09-27.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import UIKit

/// ViewController for the CategoryPopover
class RolePopoverViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    /// The current CategoryPopoverDelegate
    var controllerDelegate : RolePopoverControllerDelegate?
    var roles : [Role] = []
    var validRolesToSelect : [Role] = []
    @IBOutlet var roleTable : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.roles = DatabaseAccess.getRoles()
        for role in roles {
            if role.id != mainDelegate.loggedEmployee!.role.id && role.id > mainDelegate.loggedEmployee!.role.id {
                validRolesToSelect.append(role)
            }
        }
        
        DispatchQueue.main.async {
            self.roleTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return validRolesToSelect.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell : DatabaseIdTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "role") as? DatabaseIdTableViewCell ?? DatabaseIdTableViewCell(style:UITableViewCell.CellStyle.default, reuseIdentifier: "role")
        
        let cellBackgroundView = UIView()
        cellBackgroundView.backgroundColor = .systemBlue
        
        tableCell?.textLabel?.font = UIFont.systemFont(ofSize: 24)
        tableCell?.textLabel?.text = validRolesToSelect[indexPath.row].name
        tableCell?.databaseId = (Int)(validRolesToSelect[indexPath.row].id)
        tableCell?.selectedBackgroundView = cellBackgroundView
        
        return tableCell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let displayCell = cell as! DatabaseIdTableViewCell
        if (controllerDelegate?.getRole() != nil) {
            if (String(displayCell.databaseId!) == (controllerDelegate!.getRole()?.id)!) {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath) as! DatabaseIdTableViewCell
        let selectedCellContent = selectedCell.databaseId!
        
        controllerDelegate?.setEditRole(role: validRolesToSelect.first(where: {$0.id == String(selectedCellContent)})!)
    }
}
