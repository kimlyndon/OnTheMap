//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Kim Lyndon on 10/4/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    
    //Login
    func loginForPublicUserData(email: String, password: String, completionHandlerForLogin: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        let request = myURLRequest(withBaseURLString: UdacityConstants.UdacityURL.BaseURL, headerFields: ["Accept":"application/json", "Content-Type":"application/json"], HTTPMethod: "POST", HTTPBody: "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}")
        
        guard let urlRequest = request else {
            let userInfo = [NSLocalizedDescriptionKey: "Invalid URL Request"]
            completionHandlerForLogin(false, NSError(domain: "logiForPublicUserData", code: 1, userInfo: userInfo))
            return
        }
    
       

    // Logout
    func logout(completionHandlerForLogout: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
    
    let request = myURLRequest(withBaseURLString: UdacityConstants.UdacityURL.BaseURL, headerFields: nil, HTTPMethod: UdacityConstants.HttpMethod.Delete, HTTPBody: nil)
    
    var xsrfCookie: HTTPCookie? = nil
    let sharedCookieStorage = HTTPCookieStorage.shared
    for cookie in sharedCookieStorage.cookies! {
        if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
    }
    guard let cookie = xsrfCookie, var urlRequest = request else {
        let userInfo = [NSLocalizedDescriptionKey:"Logout Fail"]
        completionHandlerForLogout(false, NSError(domain: "logout", code: 1, userInfo: userInfo))
        return
}
}
}
}

