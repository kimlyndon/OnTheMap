//
//  LoginViewController.swift
//  On The Map
//
//  Created by Kim Lyndon on 9/11/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: Properties
    var keyboardVisible = false
    
    //MARK: Outlets
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var SignUpButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureTextFields()
        
    }
    
    @IBAction func LoginButtonPressed(_ sender: Any) {
        UdacityClient.loginForPublicUserData(
    
    
}

    @IBAction signUpPressed(_ sender: AnyObject) {
    UIApplication.shared.open(URL(string: UdacityConstants.UdacityURL.SignUpURL)!), options: [:], completionHandler: nil)
    }
    
    @IBAction func userDidTapView(_ sender: AnyObject) {
        resignIfFirstResponder(EmailTextField)
        resignIfFirstResponder(PasswordTextField)
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

    func configureTextFields() {
        EmailTextField.delegate = self
        PasswordTextField.delegate = self
        EmailTextField.text = ""
        PasswordTextField.text = ""
}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
}
}
