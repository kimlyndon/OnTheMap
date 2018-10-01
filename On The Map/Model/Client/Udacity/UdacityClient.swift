//
//  UdacityClient.swift
//  On The Map
//
//  Created by Kim Lyndon on 9/12/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import Foundation

class UdacityClient : NSObject {
    
    //Mark Properties
    var session = URLSession.shared
    var sessionID: String? = nil

    
//MARK: Initializers
    override init() {
        super.init()
        
    }
    
       


// MARK: Methods
    

                
            }
            
    
            
//func taskForPostSession {}

//func taskForDeleteSession {}

//MARK: Helpers

private func udacityURLFromParameters(_ method: String, parameter: String? = nil) -> URL {
    
    var components = URLComponents()
    components.scheme = UdacityConstants.UdacityURL.ApiScheme
    components.host = UdacityConstants.UdacityURL.ApiHost
    
    if parameter != nil {
        components.path = UdacityConstants.UdacityURL.ApiPath + method + "/" + parameter!
    } else {
        components.path = UdacityConstants.UdacityURL.ApiPath + (method)
    }
    return components.url!
}

private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
    
    var parsedResult: AnyObject! = nil
    do {
        // Skip first 5 characters of data
        let range = Range(5..<data.count)
        let newData = data.subdata(in: range)
        print(String(data: newData, encoding: .utf8)!)
        //print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
        parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
    } catch {
        let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
        completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
    }
    completionHandlerForConvertData(parsedResult, nil)
}

// MARK: Shared Instance

 func sharedInstance() -> UdacityClient {
    struct Singleton {
        static var sharedInstance = UdacityClient()
}
return Singleton.sharedInstance

}

