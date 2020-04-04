//
//  LoginViewController.swift
//  GlacoOrderApp
//
//  Created by Xcode User on 2020-04-03.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var tfID: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func loginButtonTapped(_ sender: AnyObject) {
        
        //Textfields
        let employeeID = tfID.text;
        
        if employeeID!.isEmpty
        {
            return
        }
        
        let myUrl = URL(string: "http://142.55.32.86:50131/cheriebistro/api/loginUser.php")!
        let request = NSMutableURLRequest(url: myUrl)
        request.httpMethod = "POST"
        let semaphore = DispatchSemaphore(value: 0)

        let postString = "employeeID=\(employeeID!)"
        request.httpBody = postString.data(using: String.Encoding.utf8)

        let task = URLSession.shared.dataTask(with: request as URLRequest)
        {
        data, response, error in
            if error != nil
            {
                print("error")
            
                return
            }
            do
            {
                var LoginJSON : NSDictionary!
                LoginJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
            
                if let parseJSON = LoginJSON {
                    let response:String = parseJSON["status"] as! String;
                    print("result: \(response)")

                    if(response == "Success")
                    {
                         DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "loginView", sender: nil)
                        }
                    }
                    else{
                        DispatchQueue.main.async {
                               let alertController = UIAlertController(title: "Error", message: "Wrong Employee ID", preferredStyle: .alert)
                               let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                                    alertController.addAction(cancelAction)
                               self.present(alertController, animated: true)
                    }
                }
                }
            }
            catch
            {
                print(error)
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(wallTimeout: .distantFuture)
        return
    }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


