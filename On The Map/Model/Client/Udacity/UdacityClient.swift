//
//  UdacityClient.swift
//  On The Map
//
//  Created by Kim Lyndon on 9/12/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import Foundation

class UdacityClient {
    
    //Mark Properties
    var sessionID: String?

    static var sharedInstance = UdacityClient()
       


// MARK: Methods
    
//func taskForPOSTASesson() {}

//func taskForGETPublicUserData() {}

//func taskForDeleteSession {}
    
// Login using Udacity credentials
    

    func login(_ username: String, password: String, completionHandler: @escaping (_ sessionID: String?) -> Void) {

    var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)

    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = "{\"udacity\": {\"username\": \"account@domain.com\", \"password\": \"********\"}}".data(using: .utf8)
    
    let session = URLSession.shared
    
    let task = session.dataTask(with: request) { (data, response, error) in
        if error != nil { // Handle error: TODO
           return
        }
        
// Skip first 5 characters of data
        let range = Range(5..<data!.count)
        let newData = data?.subdata(in: range)
        print(String(data: newData!, encoding: .utf8)!)
}
        
task.resume()
        
}

}



