//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Kim Lyndon on 9/11/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import Foundation
extension UdacityClient {
    
class UdacityConstants {

    
    struct UdacityURL {
        static let ApiScheme: String = "https"
        static let ApiHost: String = "www.udacity.com"
        static let ApiPath: String = "/api"
        static let BaseURL: String = "https://www.udacity.com/api/session"
        static let SignUpURL: String = "https://www.udacity.com/account/auth#!/signup"
        static let PublicUserData: String = "https://www.udacity.com/api/user/11038845303"
            
    }
   
    struct HttpMethod {
        static let Get = "GET"
        static let Post = "POST"
        static let Put = "PUT"
        static let Delete = "DELETE"
    
    }
    
    struct APIBodyKeys {
        static let Udacity = [Username:Password]
        static let Username = "username"
        static let Password = "password"
        static let AccessToken = "access_token"
        
    }
    
    struct APIResponseKeys {
        static let Account = "account"
        static let Registered = "registered"
        static let Session = "session"
        static let ID = "id"
        static let Key = "key"
        static let User = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
        static let Expiration = "expiration"
        static let userID = "user_id"
        
    }
    
    struct ErrorMessages {
        static let UsernamePasswordError = "Login attempt failed. Please check your username or password."
        static let NetworkConnectionError = "Login attempt failed. The Internet connection appears to be offline."
      }


}
}
