//
//  AddFoodCategoryViewController.swift
//  GlacoOrderApp
//
//  Created by Parker Christie on 2020-03-10.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import UIKit

class AddFoodCategoryViewController: UIViewController {
    
    
    @IBOutlet var categoryTextField: UITextField!
    @IBOutlet var addCategoryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCategoryButton.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCateogryTextFieldChange(_ sender: Any) {
        let checkString : String = (categoryTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        if checkString.isEmpty {
            addCategoryButton.isEnabled = false
        }
        else {
            addCategoryButton.isEnabled = true
        }
    }
    
    @IBAction func addFoodCategoryButtonPressed(_ sender: Any) {
        
        let addAlert = UIAlertController(title: "Add Category", message: "Do you want to add the food category " + categoryTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) + "?", preferredStyle: UIAlertController.Style.alert)

        addAlert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action: UIAlertAction!) in
              print("Handle Ok logic here")
        }))

        addAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(addAlert, animated: true, completion: nil)
    }
}
