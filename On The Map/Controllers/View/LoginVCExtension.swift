//
//  LoginVCExtension.swift
//  On The Map
//
//  Created by Kim Lyndon on 10/18/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension UIViewController {
    
    //NOTE FROM PHUC TRAN: sending request on server and get error, please use Alert to show error message 
    
    
    
    // MARK: Alerts
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: URL open
    func verifyUrl (urlString: String?) -> Bool {
        
        let app = UIApplication.shared
        
        if let urlString = urlString {
            if let url  = NSURL(string: urlString) {
                return app.canOpenURL(url as URL)
            }
        }
        return false
}

    // MARK: Keyboard Methods
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        
        
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        //self.view.frame.origin.y =  getKeyboardHeight(notification) * -0.3
        
    }
    
    // move the view back down when the keyboard is dismissed
    @objc func keyboardWillHide(_ notification:Notification) {
     
        view.frame.origin.y = 0
        
    }
    
    func subscribeToKeyboardNotifications() {
     
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:))    , name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
     
    }
}

extension LoginViewController {
    
    func disableUI() {
        EmailTextField.isEnabled = false
        PasswordTextField.isEnabled = false
        LoginButton.isEnabled = false
        SignUpButton.isEnabled = false
    }
    
    func enableUI() {
        EmailTextField.isEnabled = true
        PasswordTextField.isEnabled = true
        EmailTextField.text = ""
        PasswordTextField.text = ""
        LoginButton.isEnabled = true
        SignUpButton.isEnabled = true
    }
    
    
    // removes the text keyboard after touching anywhere else on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        EmailTextField.resignFirstResponder()
        PasswordTextField.resignFirstResponder()
    }
}

extension AddLocationViewController {
    
    func disableUI() {
        enterLocationTextField.isEnabled = false
        enterURLTextField.isEnabled = false
        findLocationButton.isEnabled = false
    }
    
    func enableUI() {
        enterLocationTextField.isEnabled = true
        enterURLTextField.isEnabled = true
        findLocationButton.isEnabled = true
    }
    
    
    // removes the text keyboard after touching anywhere else on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        enterLocationTextField.resignFirstResponder()
        enterURLTextField.resignFirstResponder()
    }
}




