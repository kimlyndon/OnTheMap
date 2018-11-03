//
//  LoginViewController.swift
//  On The Map
//
//  Created by Kim Lyndon on 9/11/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    //MARK: Outlets
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var SignUpButton: UIButton!
    
    @IBOutlet weak var logoImage: UIImageView!
    
    
    //MARK: Properties
    var keyboardVisible = false
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
       unsubscribeFromKeyboardNotifications()
       
        // Clear out login screen
        enableUI()

    }
    
    //MARK: Actions (Note from Phuc Tran: While checking credentials, disable login button. )
    
    // 1. Check for empty text fields.
    @IBAction func LoginButtonPressed(_ sender: UIButton) {
        guard let username = EmailTextField.text, username != "" else {
            print("username is empty")
            createAlert(title: "Error", message: "Please enter your username (email address)")
            return
        }
        guard let password = PasswordTextField.text, password != "" else {
            print("password is empty")
            createAlert(title: "Error", message: "Please enter your password")
            return
        }
        
        self.disableUI()
        
        // 2. Call 'authenticateUser'
       
        UdacityClient.sharedInstance().authenticateUser(myUserName: username, myPassword: password) { (success, errorString) in
            
            // if 'success' returned false then enter Guard Statement
            guard (success == true) else {
               
                // display the errorString using createAlert
                    performUIUpdatesOnMain {
                    self.createAlert(title: "Error", message: errorString)
                    self.enableUI()
                }
                
                return
            }
            
            // If 'success' was true, then continue with collecting data
            print("Successfully authenicated the Udacity user.")
            
            // 3. Call 'getPublicUserData (Get first and last name to store in UdacityClient)
            UdacityClient.sharedInstance().getPublicUserData() { (data, errorString) in
                guard (success == true) else {
                
                    print("Unsuccessful in obtaining firstName and lastName from Udacity Public User Data: \(errorString)")
                    
                    performUIUpdatesOnMain {
                        self.createAlert(title: "Error", message: "Login attempt did not result in a 'success' in obtaining first and last name from Udacity Public User Data")
                        self.enableUI()
                    }
                    
                    return
                }
                print("Successfully obtained first and last name from Udacity Public User Data")
                
                // MARK: 4. Get the User Student location(s) 
                ParseClient.sharedInstance().taskForGetALocation() { (data, errorString) in
                    guard data != nil else {
                        print("Unsuccessful in obtaining A Student Location from Parse: \(String(describing: errorString))")
                        
                        performUIUpdatesOnMain {
                            self.createAlert(title: "Error", message: "Unable to obtain Student Location data.")
                            self.enableUI()
                        }
                        return
                    }
                    
                    
                    // MARK: if UserLocation.UserData.objectId != ""  a student location was retrieved
                    print("Successfully obtained one Student Location data from Parse.")
                    print("objectId: \(StudentInformation.UserData.objectId)")
                    print("uniqueKey: \(StudentInformation.UserData.uniqueKey)")
                    
                    
                    // MARK: 5. Get 100 student locations from Parse
                    ParseClient.sharedInstance().taskForGETLocationsRequest() { (data, errorString) in
                        
                        guard (success == true) else {
                            print("Unsuccessful in obtaining Student Locations from Parse: \(String(describing: errorString))")
                            
                            performUIUpdatesOnMain {
                                self.createAlert(title: "Error", message: "Failure to download student locations data.")
                                self.enableUI()
                            }
                            return
                        }
                        print("Successfully obtained Student Locations data from Parse")
                        
                        // After all are successful, completeLogin
                        self.completeLogin()
                        
                    }
                }
            }
        }
    }

    @IBAction func signUpPressed(_ sender: AnyObject) {
     // Segue to Safari
    }
    
    
private func completeLogin() {
    
    performUIUpdatesOnMain {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "InitialNavigationController") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
        }
    }
}





