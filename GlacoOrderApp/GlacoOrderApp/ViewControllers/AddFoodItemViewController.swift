//
//  AddFoodItemViewController.swift
//  GlacoOrderApp
//
//  Created by Parker Christie on 2020-03-10.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import UIKit
import QuartzCore

class AddFoodItemViewController: UIViewController, CategoryPopoverControllerDelegate {
    
    internal var categories : [String] = []

    @IBOutlet var DescriptionTextView: UITextView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var priceTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DescriptionTextView.layer.borderWidth = 0.5
        DescriptionTextView.layer.cornerRadius = 5
        DescriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        // Do any additional setup after loading the view.
    }
    
    @IBAction func displayPopover(_ sender: UIButton) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CategoryPopoverViewController") as! CategoryPopoverViewController
        vc.modalPresentationStyle = .popover
        vc.controllerDelegate = self
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        popover.sourceView = sender
        present(vc, animated: true, completion:nil)
    }
    
    @IBAction func submitAddFoodItem(_ sender: Any) {
        
        
        let alertBox = UIAlertController(title: "Add Food Item", message: "Are you sure you want to add \(nameTextField.text!) to the menu?", preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: "Confirm", style: .default, handler: { (alert) in
            // HANDLE ADDING OF FOOD ITEM
        })
        
        alertBox.addAction(noAction)
        alertBox.addAction(yesAction)
        
        self.present(alertBox, animated: true, completion: nil)
    }
    
    func addCategory(category: String) {
        categories.append(category)
    }
    
    func removeCategory(category: String) {
        categories.remove(at: (categories.firstIndex(of: category)!))
    }
    
    

}
