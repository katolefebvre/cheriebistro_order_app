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
            let response : [String : String] = DatabaseAccess.addCategory(name: self.categoryTextField.text!)
            if response["error"] == "false" {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Upload Successful", message: "Category added successfully.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.categoryTextField.text=""
                }
            } else {
                self.showError(message: "Category name already exists")
            }
        }))

        addAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(addAlert, animated: true, completion: nil)
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
