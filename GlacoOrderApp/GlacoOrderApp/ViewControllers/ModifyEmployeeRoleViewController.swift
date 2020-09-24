//
//  ModifyEmployeeRoleViewController.swift
//  GlacoOrderApp
//
//  Created by Parker Christie on 2020-09-23.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import UIKit

class ModifyEmployeeRoleViewController : UIViewController, UITextFieldDelegate, EmployeePopoverControllerDelegate {
    
    var editEmployee : Employee?
    
    func getEmployees() -> [Employee] {
        return []
    }
    
    func setEditEmployee(employee: Employee) {
        return
    }
    
    func setEmployeeRole(employee: Employee, roleID: String) {
        return
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
}
