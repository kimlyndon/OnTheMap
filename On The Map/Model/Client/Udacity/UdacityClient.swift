//
//  UdacityClient.swift
//  On The Map
//
//  Created by Kim Lyndon on 9/12/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import Foundation

class UdacityClient {

func login(username: String, password: String, completionHandler: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
    var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = "{\"udacity\": {\"username\": \"account@domain.com\", \"password\": \"********\"}}".data(using: .utf8)
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
        if error != nil {
            return
        }
        let range = Range(5..<data!.count)
        let newData = data?.subdata(in: range)
        print(String(data: newData!, encoding: .utf8)!)
}
task.resume()
}

}
