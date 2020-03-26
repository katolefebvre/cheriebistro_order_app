//
//  AddFoodItemViewController.swift
//  GlacoOrderApp
//
//  Created by Parker Christie on 2020-03-10.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import UIKit
import QuartzCore

/// ViewController for the page for adding new MenuItems to the application.
class AddFoodItemViewController: UIViewController, CategoryPopoverControllerDelegate, TimeSlotPopoverControllerDelegate {
    
    /// The currently selected TimeSlot for the MenuItem to be added.
    private var timeSlot : TimeSlot?
    
    /// The currenty selected categories for the MenuItem to be added.
    private var categories : [Category] = []
    
    /// The TextView of the description.
    @IBOutlet var tvDescription: UITextView!
    
    /// The TextField of the name of the MenuItem.
    @IBOutlet var tfName: UITextField!
    
    /// The price of the Menuitem.
    @IBOutlet var tfPrice: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvDescription.layer.borderWidth = 0.5
        tvDescription.layer.cornerRadius = 5
        tvDescription.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
    /// Displays the popover for the time slot table.
    /// - Parameter sender: The button triggering the display.
    @IBAction func displayTimeSlotPopover(_ sender : UIButton) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TimeSlotPopoverViewController") as! TimeSlotPopoverViewController
        vc.modalPresentationStyle = .popover
        vc.controllerDelegate = self
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        popover.sourceView = sender
        present(vc, animated: true, completion:nil)
    }
    
    
    /// Displays the popover for the category table.
    /// - Parameter sender: The button triggering the display.
    @IBAction func displayCategoryPopover(_ sender: UIButton) {
           let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
           let vc = storyboard.instantiateViewController(withIdentifier: "CategoryPopoverViewController") as! CategoryPopoverViewController
           vc.modalPresentationStyle = .popover
           vc.controllerDelegate = self
           let popover: UIPopoverPresentationController = vc.popoverPresentationController!
           popover.sourceView = sender
           present(vc, animated: true, completion:nil)
    }
    
    
    /// Prepares a food item to be stored in the database and sends the request to DatabaseAccess.
    /// - Parameter sender: The element triggering the submit action.
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
    
    
    /// Show an error as an UI Alert message.
    /// - Parameter message: The content of the UI Alert message.
    func showError(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Failure Occurred", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    /// Retrieves the category array containing selected categories.
    func getCategories() -> [Category] {
        return categories
    }
    
    
    /// Add a selected category to the categories list.
    /// - Parameter category: The category to be added to the list.
    func addCategory(category: Category) {
        categories.append(category)
    }
    
    
    /// Remove a selected category from the categories list.
    /// - Parameter category: The category to be removed from the list
    func removeCategory(category: Category) {
        categories.remove(at: categories.firstIndex(where: {$0.id == category.id})!)
    }
    
    
    /// Retrieves the current TimeSlot object stored.
    func getTimeSlot() -> TimeSlot? {
        return self.timeSlot
    }
    
    
    /// Sets the current TimeSlot object to the given paramter.
    /// - Parameter timeSlot: The TimeSlot to be stored.
    func setTimeSlot(timeSlot: TimeSlot) {
        self.timeSlot = timeSlot
    }
}
