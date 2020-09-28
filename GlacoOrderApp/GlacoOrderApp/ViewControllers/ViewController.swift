//
//  ViewController.swift
//  GlacoOrderApp
//
//  Created by Parker Christie on 2020-03-10.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var employeeNameLabel: UILabel!
    @IBOutlet var roleNameLabel: UILabel!
    @IBOutlet var addFoodItemButton: UIButton!
    @IBOutlet var addFoodCategoryButton: UIButton!
    @IBOutlet var modifyEmployeeRoleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let employee = mainDelegate.loggedEmployee {
            employeeNameLabel.isHidden = false
            employeeNameLabel.text = "Logged In As: \(employee.name)"
            
            roleNameLabel.isHidden = false
            roleNameLabel.text = "Current Role: \(employee.role.name)"
            
            if Int(employee.role.id)! > 2 {
                addFoodItemButton.isHidden = true
                addFoodCategoryButton.isHidden = true
                modifyEmployeeRoleButton.isHidden = true
            }
            
            else {
                addFoodItemButton.isHidden = false
                addFoodCategoryButton.isHidden = false
                modifyEmployeeRoleButton.isHidden = false
            }
        }
        else {
            employeeNameLabel.isHidden = true
            roleNameLabel.isHidden = true
            _ = navigationController?.popViewController(animated: true)
        }
        
    }
 
}

