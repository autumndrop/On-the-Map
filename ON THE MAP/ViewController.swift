//
//  ViewController.swift
//  ON THE MAP
//
//  Created by liang on 4/15/16.
//  Copyright © 2016 liang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginPressed(sender: AnyObject) {
        userDidTapView()
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty{
            debugTextLabel.text = "Username or Password Empty."
        }else{
            setUIEnabled(false)
        }
        createSession()
    }
    
    private func createSession(){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        let username = self.usernameTextField.text
        let password = self.passwordTextField.text
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username!)\", \"password\": \"\(password!)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
//        print("{\"udacity\": {\"username\": \"\(username!)\", \"password\": \"\(password!)\"}}")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            func displayError(error: String) {
                print(error)
                performUIUpdatesOnMain {
                    self.setUIEnabled(true)
                    self.debugTextLabel.text = "Login Failed (Create Session)."
                }
            }
            
            if error != nil { // Handle error…
                displayError("Error")
                return
            }
            print(data)
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            let parsedResult:AnyObject!
            do{
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            }catch{
                displayError("Parse Data")
                return
            }
            
            guard let account = parsedResult["account"] as? [String:AnyObject] else{
                displayError("Find Account")
                return
            }
            
            guard let register = account["registered"] as? Bool where register == true else{
                displayError("Find Registered")
                return
            }
            
            print("Success")
            self.completeLogin()
        }
        task.resume()
    }
    
    func userDidTapView(){
        resignIfFirstResponder(usernameTextField)
        resignIfFirstResponder(passwordTextField)
    }
    
    func resignIfFirstResponder(textField: UITextField){
        if textField.isFirstResponder(){
            textField.resignFirstResponder()
        }
    }
    
    private func setUIEnabled(enabled: Bool) {
        usernameTextField.enabled = enabled
        passwordTextField.enabled = enabled
        loginButton.enabled = enabled
        debugTextLabel.text = ""
        debugTextLabel.enabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
    private func completeLogin() {
        performUIUpdatesOnMain {
            self.debugTextLabel.text = ""
            self.setUIEnabled(true)
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
}

