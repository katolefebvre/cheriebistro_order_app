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
    
    internal var timeSlot: Int = 0
    internal var categories : [Int] = []

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
            self.sendToDB()
        })
        
        alertBox.addAction(noAction)
        alertBox.addAction(yesAction)
        
        self.present(alertBox, animated: true, completion: nil)
    }
    
    func sendToDB() {
        let address = URL(string: "http://142.55.32.86:50131/cheriebistro/api/addfooditem.php")!
        let url = NSMutableURLRequest(url: address)
        url.httpMethod = "POST"
        
        var dataString = "name=\(tfName.text!)"
        dataString = dataString + "&description=\(tvDescription.text!)"
        dataString = dataString + "&time_slot_id=\(timeSlot)"
        dataString = dataString + "&price=\(tfPrice.text!)"
        
        let dataD = dataString.data(using: .utf8)
        
        do {
            let uploadJob = URLSession.shared.uploadTask(with: url as URLRequest, from: dataD) {
                data, response, error in
                if error != nil {
                    self.showError(message: "Failed to connect.")
                } else {
                    if let unwrappedData = data {
                        let jsonResponse = try! JSONSerialization.jsonObject(with: unwrappedData, options: [])
                        guard let jsonArray = jsonResponse as? [String: String] else {
                            return
                        }

                        if jsonArray["error"] == "false" {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Upload Successful", message: "Menu item added successfully.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        } else {
                            self.showError(message: "Menu item failed to upload.")
                        }
                    }
                }
            }
            uploadJob.resume()
        }
    }
    
    func showError(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Failure Occurred", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func addCategory(categoryId : Int) {
        categories.append(categoryId)
    }
    
    func removeCategory(categoryId : Int) {
        categories.remove(at: (categories.firstIndex(of: categoryId)!))
    }
}
