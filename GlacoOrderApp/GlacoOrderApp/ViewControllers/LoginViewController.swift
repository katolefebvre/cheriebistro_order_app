//
//  LoginViewController.swift
//  GlacoOrderApp
//
//  Created by Xcode User on 2020-04-03.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var idTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.isEnabled = false
        mainDelegate.loggedEmployee = nil
    }
    
    @IBAction func onIdTextFieldChange(_ sender: Any) {
        let checkString : String = (idTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        if checkString.isEmpty {
            loginButton.isEnabled = false
        }
        else {
            loginButton.isEnabled = true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 10
    }
    
    @IBAction func loginButtonTapped(_ sender: AnyObject) {
        
        //Textfields
        let employeeID = idTextField.text;
        
        if employeeID!.isEmpty
        {
            return
        }
        
        if let foundEmployee = DatabaseAccess.loginEmployee(loginId: employeeID!) {
            
            mainDelegate.loggedEmployee = foundEmployee
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "loginView", sender: nil)
            }
        }
            else {
            let alertController = UIAlertController(title: "Error", message: "Invalid Employee ID", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                 alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }

    }
}


