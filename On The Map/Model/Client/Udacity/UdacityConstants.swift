//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Kim Lyndon on 9/11/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import Foundation

extension UdacityClient {


class UdacityConstants  {
        
    
    struct UdacityURL {
        static let BaseURL: String = "https://www.udacity.com/api/session"
        static let SignUpURL: String = "https://www.udacity.com/account/auth#!/signup"
        static let publicUserData: String = "https://www.udacity.com/api/users"
            
    }
   
    struct HttpMethod {
        static let Get = "GET"
        static let Post = "POST"
        static let Put = "PUT"
        static let Delete = "DELETE"
    
    }
    
    struct APIResponseKeys {
        static let account = "account"
        static let key = "key"
        static let user = "user"
        static let firstName = "first_name"
        static let lastName = "last_name"
        
    }
    
  }

}
