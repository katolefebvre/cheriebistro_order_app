//
//  AddFoodItemViewController.swift
//  GlacoOrderApp
//
//  Created by Parker Christie on 2020-03-10.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import UIKit
import QuartzCore

class AddFoodItemViewController: UIViewController {

    @IBOutlet var DescriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DescriptionTextView.layer.borderWidth = 0.5
        DescriptionTextView.layer.cornerRadius = 5
        DescriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        // Do any additional setup after loading the view.
    }
    
    

}
