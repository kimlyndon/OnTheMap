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
    //GET
    
    func taskForGETMethod(_ method: String, parameters: String, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        //Build URL, configure request
        let request = NSMutableURLRequest(url: udacityURLFromParameters(method))
        //Make request
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "UdacityClient (taskForGETMethod", code: 1, userInfo: userInfo))
            }
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2XX.")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request.")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            
            var parsedJSON: AnyObject? = nil
            
            // Turn the raw data into JSON then a foundation object
            do {
                
                let json = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
                parsedJSON = json
                
            } catch {
                sendError("Could not turn raw data into a foundation object")
            }
            
            guard let parsedResult = parsedJSON else {
                sendError("parsedJSON did not fall through")
                return
                
            }
            
            completionHandlerForGET(parsedResult, nil)
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        task.resume()
        return task
    }
            
    //MARK: POST
    func taskForPOSTMethod(_ method: String, parameters: [String: AnyObject], completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        //Convert dictionary to JSON
        let requestBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        //Build URL, configure rquest
        let request = NSMutableURLRequest(url: udacityURLFromParameters(method))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBody
        
        //Make request
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "UdacityClient (taskforPOSTMethod)", code: 1, userInfo: userInfo))
                }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2XX.")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        task.resume()
        return task
    }
    
    //MARK: POST
    func taskForDELETESession(_ method: String, completionHandlerForDELETE: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        //Build URL, Configure request
        let request = NSMutableURLRequest(url: udacityURLFromParameters(method))
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        //Make the request
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForDELETE(nil, NSError(domain: "UdacityClient (taskForDELETEMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2XX.")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request.")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForDELETE)
        }
        
        task.resume()
        return task
    }

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
    
    func myURLRequest(withBaseURLString urlString: String, headerFields headers: [String:String]?, HTTPMethod method: String, HTTPBody body: String?) -> URLRequest? {
        
        guard let url = URL(string: urlString) else { return nil }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = method
        if let jsonBody = body {
            request.httpBody = jsonBody.data(using: .utf8)
        }
        
        guard let headers = headers else { return request as URLRequest }
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        return request as URLRequest
    }

    // MARK: Singleton
    static func singleton() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
}

}
