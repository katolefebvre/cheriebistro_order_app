//
//  AddFoodItemViewController.swift
//  GlacoOrderApp
//
//  Created by Parker Christie on 2020-03-10.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import UIKit
import QuartzCore

class AddFoodItemViewController: UIViewController, CategoryPopoverControllerDelegate, TimeSlotPopoverControllerDelegate {

    private var timeSlot : TimeSlot?
    private var categories : [Category] = []

    @IBOutlet var tvDescription: UITextView!
    @IBOutlet var tfName: UITextField!
    @IBOutlet var tfPrice: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvDescription.layer.borderWidth = 0.5
        tvDescription.layer.cornerRadius = 5
        tvDescription.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func displayTimeSlotPopover(_ sender : UIButton) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TimeSlotPopoverViewController") as! TimeSlotPopoverViewController
        vc.modalPresentationStyle = .popover
        vc.controllerDelegate = self
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        popover.sourceView = sender
        present(vc, animated: true, completion:nil)
    }
    
    @IBAction func displayCategoryPopover(_ sender: UIButton) {
           let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
           let vc = storyboard.instantiateViewController(withIdentifier: "CategoryPopoverViewController") as! CategoryPopoverViewController
           vc.modalPresentationStyle = .popover
           vc.controllerDelegate = self
           let popover: UIPopoverPresentationController = vc.popoverPresentationController!
           popover.sourceView = sender
           present(vc, animated: true, completion:nil)
    }
    
    @IBAction func submitAddFoodItem(_ sender: Any) {
        let alertBox = UIAlertController(title: "Add Food Item", message: "Are you sure you want to add \(tfName.text!) to the menu?", preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: "Confirm", style: .default, handler: { (alert) in
            
            let response : [String : String] = DatabaseAccess.addMenuItem(name: self.tfName.text!, description: self.tvDescription.text!, timeslotID: self.timeSlot!.id!, price: self.tfPrice.text!, categoryIds: self.categories.map {$0.id})
            if response["error"] == "false" {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Upload Successful", message: "Menu item added successfully.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                self.showError(message: "Menu item failed to upload.")
            }
        })
        
        alertBox.addAction(noAction)
        alertBox.addAction(yesAction)
        
        self.present(alertBox, animated: true, completion: nil)
    }
    
    func showError(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Failure Occurred", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getCategories() -> [Category] {
        return categories
    }
    
    func addCategory(category: Category) {
        categories.append(category)
    }
    
    func removeCategory(category: Category) {
        categories.remove(at: categories.firstIndex(where: {$0.id == category.id})!)
    }
    
    func getTimeSlot() -> TimeSlot? {
        return self.timeSlot
    }
    
    func setTimeSlot(timeSlot: TimeSlot) {
        self.timeSlot = timeSlot
    }
}
