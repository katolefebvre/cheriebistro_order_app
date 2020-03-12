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
    
    var categories : [String] = []

    @IBOutlet var DescriptionTextView: UITextView!
    
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
        for category in categories {
            print(category)
        }
    }
    
    func addCategory(category: String) {
        categories.append(category)
    }
    
    func removeCategory(category: String) {
        categories.remove(at: (categories.firstIndex(of: category)!))
    }
    
    

}
