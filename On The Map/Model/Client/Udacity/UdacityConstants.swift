//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Kim Lyndon on 9/11/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import Foundation
extension UdacityClient {
    

struct Constants {
        
}

struct UdacityConstants {
    static let BaseURL: String = "https://www.udacity.com/api/session"
    static let SignUpURL: String = "https://www.udacity.com/account/auth#!/signup"
}

struct Methods {
    static let Session = "/session"
    static let User = "/users"
}
   
struct HttpMethod {
    static let Get = "GET"
    static let Post = "POST"
    static let Put = "PUT"
    static let Delete = "DELETE"
    
    }

}

