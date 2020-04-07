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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if mainDelegate.loggedEmployee != nil {
            employeeNameLabel.isHidden = false
            employeeNameLabel.text = "Logged In As: \(mainDelegate.loggedEmployee!.name)"
        }
        else {
            employeeNameLabel.isHidden = true
        }
    }
 
}

