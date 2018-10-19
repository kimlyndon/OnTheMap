//
//  SignUpViewController.swift
//  On The Map
//
//  Created by Kim Lyndon on 10/18/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import UIKit
import WebKit

class SignUpViewController: UIViewController {
   

    @IBOutlet weak var webView: WKWebView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let url = URL(string: "https://auth.udacity.com/sign-up")
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
}


