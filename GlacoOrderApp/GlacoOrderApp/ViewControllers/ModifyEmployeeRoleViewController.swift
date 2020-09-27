//
//  ModifyEmployeeRoleViewController.swift
//  GlacoOrderApp
//
//  Created by Parker Christie on 2020-09-23.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import UIKit

class ModifyEmployeeRoleViewController : UIViewController, UITextFieldDelegate, EmployeePopoverControllerDelegate, RolePopoverControllerDelegate {
    
    @IBOutlet var selectedEmployeeLabel: UILabel!
    @IBOutlet var selectedRoleLabel: UILabel!
    var editEmployee : Employee?
    var editRole : Role?
    
    func getEmployee() -> Employee? {
        if let employee = editEmployee {
            return employee
        }
        else {
            return nil
        }
    }
    
    func setEditEmployee(employee: Employee) {
        editEmployee = employee
        if let validEmployee = editEmployee {
            selectedEmployeeLabel.text = validEmployee.name
        }
        else {
            selectedEmployeeLabel.text = ""
        }
    }
    
    func getRole() -> Role? {
        if let role = editRole {
            return role
        }
        else {
            return nil
        }
    }
    
    func setEditRole(role : Role) {
        editRole = role
        if let validRole = editRole {
            selectedRoleLabel.text = validRole.name
        }
        else {
            selectedRoleLabel.text = ""
        }
    }
    
    
    @IBAction func displayEmployeePopover(_ sender : UIButton) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EmployeePopoverViewController") as! EmployeePopoverViewController
        vc.modalPresentationStyle = .popover
        vc.controllerDelegate = self
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        popover.sourceView = sender
        present(vc, animated: true, completion:nil)
    }
    
    @IBAction func displayRolePopover(_ sender: UIButton) {
        let storyboard : UIStoryboard = UIStoryboard(name : "Main", bundle : nil)
        let vc = storyboard.instantiateViewController(identifier: "RolePopoverViewController") as! RolePopoverViewController
        vc.modalPresentationStyle = .popover
        vc.controllerDelegate = self
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        popover.sourceView = sender
        present(vc, animated: true, completion:nil)
    }
    
    @IBAction func submitRoleChange(_ sender: UIButton) {
        
        let changeRoleAlert = UIAlertController(title: "Change Roles", message: "Do you want to assign the role of " + getRole()!.name + " to " + getEmployee()!.name + "?", preferredStyle: UIAlertController.Style.alert)
        
        changeRoleAlert.addAction(UIAlertAction(title: "Change", style : .default, handler : { [self] (action : UIAlertAction!) in
            let response : [String : String] = DatabaseAccess.changeRole(employeeID: getEmployee()!.id, roleID: self.getRole()!.id)
            if response["error"] == "false" {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Update Successful", message: "Role changed successfully.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                self.showError(message: "Role change failed.")
            }
        }))
        
        changeRoleAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(changeRoleAlert, animated : true, completion : nil)
    }
    
    /// Show an error as an UI Alert message.
    /// - Parameter message: The content of the UI Alert message.
    func showError(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Failed", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
