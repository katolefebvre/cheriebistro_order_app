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
    @IBOutlet var currentRoleLabel: UILabel!
    @IBOutlet var selectedRoleLabel: UILabel!
    private var editEmployee : Employee?
    private var editRole : Role?
    
    func getEmployee() -> Employee? {
        if let employee = editEmployee {
            return employee
        }
        else {
            return nil
        }
    }
    
    func setEmployee(employee: Employee) {
        editEmployee = employee
        if let validEmployee = editEmployee {
            selectedEmployeeLabel.text = validEmployee.name
            currentRoleLabel.text = validEmployee.role.name
        }
        else {
            selectedEmployeeLabel.text = ""
            currentRoleLabel.text = ""
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
    
    func setRole(role : Role) {
        editRole = role
        if let validRole = editRole {
            selectedRoleLabel.text = validRole.name
        }
        else {
            selectedRoleLabel.text = ""
        }
    }
    
    func setCurrentRoleLabel(currentRole : Role) {
        currentRoleLabel.text = currentRole.name
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
        if getRole() != nil && getEmployee() != nil {
            let changeRoleAlert = UIAlertController(title: "Change Roles", message: "Do you want to assign the role of " + getRole()!.name + " to " + getEmployee()!.name + "?", preferredStyle: UIAlertController.Style.alert)
            
            changeRoleAlert.addAction(UIAlertAction(title: "Change", style : .default, handler : { [self] (action : UIAlertAction!) in
                if getEmployee()!.role.id == getRole()!.id {
                    self.showError(message: "Employee is already this role, please try again.")
                }
                else {
                    let response : [String : String] = DatabaseAccess.changeRole(employeeID: self.getEmployee()!.id, roleID: self.getRole()!.id)
                    if response["error"] == "false" {
                        DispatchQueue.main.async {
                            setCurrentRoleLabel(currentRole: self.getRole()!)
                            self.editEmployee!.role = self.getRole()!
                            let alert = UIAlertController(title: "Update Successful", message: "Role changed successfully.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    } else {
                        self.showError(message: "Role change failed.")
                    }
                }
            }))
            changeRoleAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            present(changeRoleAlert, animated : true, completion : nil)
        }
        else {
            showError(message: "An employee and role are required in order to complete this operation.")
        }
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
