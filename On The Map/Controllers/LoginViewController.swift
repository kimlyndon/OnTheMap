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
    
    //MARK: Properties
    var keyboardVisible = false
    
    //MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        EmailTextField.text! = ""
        PasswordTextField.text! = ""
        EmailTextField.delegate = self
        PasswordTextField.delegate = self
        
        setUIEnabled(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //MARK: Actions
    
    //Note from Phuc Tran: While checking credentials, disable login button. 
    @IBAction func LoginButtonPressed(_ sender: AnyObject) {
        userDidTapView(self)
        
        if EmailTextField.text!.isEmpty || PasswordTextField.text!.isEmpty {
            alert(title: "Error", message: "Empty Email or Password.", source: self) {
                if self.EmailTextField.text == "" {
                    self.EmailTextField.becomeFirstResponder()
                } else {
                    self.PasswordTextField.becomeFirstResponder()
                }
            }
        } else {
            setUIEnabled(false)
            
            UdacityClient.shared.taskForPOSTLoginMethod(username: EmailTextField.text!, password: PasswordTextField.text!) {
                (success, error) in
                
                if (success != nil) {
                    self.performSegue(withIdentifier: "LoggedIn", sender: self)
                } else {
                    
                    self.alert(title: "Error", message: "\(error!)", source: self) {
                        self.setUIEnabled(true)
                        self.PasswordTextField.text = ""
                    }
                }
            }
        }
    }

    @IBAction func signUpPressed(_ sender: AnyObject) {
        UIApplication.shared.open(URL(string: "\(UdacityConstants.UdacityURL.SignUpURL)")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func userDidTapView(_ sender: AnyObject) {
        resignIfFirstResponder(EmailTextField)
        resignIfFirstResponder(PasswordTextField)
}

private func setUIEnabled(_ enabled: Bool) {
    EmailTextField.isEnabled = enabled
    PasswordTextField.isEnabled = enabled
    LoginButton.isEnabled = enabled
    LoginButton.alpha = enabled ? 1.0 : 0.5
    
    }
}
    
extension UIViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    func alert(title: String, message: String, source: UIViewController, completion: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
        
        alertController.addAction(dismissAction)
        source.present(alertController, animated: true, completion: completion)
    }

}






