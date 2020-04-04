//
//  ViewController.swift
//  GlacoOrderApp
//
//  Created by Parker Christie on 2020-03-10.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
         
         let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn");
         
         if !isUserLoggedIn
         {
             self.performSegue(withIdentifier: "loginView", sender: self)
         }
     }
 
}

