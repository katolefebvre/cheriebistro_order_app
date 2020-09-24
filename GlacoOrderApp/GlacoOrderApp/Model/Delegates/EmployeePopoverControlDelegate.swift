//
//  EmployeePopoverControlDelegate.swift
//  GlacoOrderApp
//
//  Created by Parker Christie on 2020-09-23.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import Foundation

protocol EmployeePopoverControllerDelegate {
    
    func getEmployees() -> [Employee]
    func setEditEmployee(employee : Employee)
    func setEmployeeRole(employee : Employee, roleID : String)
    
}
