//
//  ParseClient.swift
//  On The Map
//
//  Created by Kim Lyndon on 9/13/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    //MARK: Properties
    var session = URLSession.shared
    
    //MARK: Initializers
    override init() {
        super.init()
    }
    
    //MARK: Methods- GET
    func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        //Build URL and Configure Request
        var request = NSMutableURLRequest(url: parseURLFromParameters(method, parameters: parameters))
        request.addValue(ParseConstants.APIHeaderValues.AppID, forHTTPHeaderField: ParseConstants.APIHeaderKeys.ID)
        request.addValue(ParseConstants.APIHeaderValues.ApiKey, forHTTPHeaderField: ParseConstants.APIHeaderKeys.key)
       
        //Make the request
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "Parse Client (taskForGETMethod)", code: 1, userInfo: userInfo))
            }
            guard (error == nil) else {
                sendError("There was an error with your request: \(String(describing: error))")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx.")
                return
            }
            guard let data = data else {
                sendError("No data was returned by the request.")
                return
            }
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        task.resume()
        return task

    }
    
    //POST
    func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask  {
        
        //Convert to JSON
        let requestBody = try? JSONSerialization.data(withJSONObject: parameters
            , options: .prettyPrinted)
        
        //Build URL Configure request
        var request = NSMutableURLRequest(url:parseURLFromParameters(method))
        request.httpMethod = ParseConstants.URLRequest.postMethod
        request.addValue(ParseConstants.APIHeaderValues.AppID, forHTTPHeaderField: ParseConstants.APIHeaderKeys.ID)
        request.addValue(ParseConstants.APIHeaderValues.ApiKey, forHTTPHeaderField: ParseConstants.APIHeaderKeys.key)
        request.addValue(ParseConstants.QueryItemValues.contentTypeValue, forHTTPHeaderField: ParseConstants.QueryItemKeys.contentType)
        request.httpBody = requestBody
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            func sendError( _error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "ParseClient (taskForPOSTMethod)", code: 1, userInfo: userInfo as [String : Any]))
            }
            guard (error == nil) else {
                sendError(_error: "There was an error with your request: \(String(describing: error))")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError(_error: "Your request returned a status code other than 2XX!")
                return
            }
            guard let data = data else {
                sendError(_error: "No data was returned by the request.")
                return
            }
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
            }
        
        task.resume()
        return task
        
    }
    
    //PUT
    func taskForPUTMethod(_ method: String, objectId: String, parameters: [String:AnyObject], completionHandlerForPUT: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        // Build the URL, Configure the request
        let request = NSMutableURLRequest(url: URL(string: ParseConstants.URL.BaseURL)!) //FIX THIS LINE!!
        request.httpMethod = "PUT"
        request.addValue(ParseConstants.APIHeaderValues.AppID, forHTTPHeaderField: ParseConstants.APIHeaderKeys.ID)
        request.addValue(ParseConstants.APIHeaderValues.ApiKey, forHTTPHeaderField: ParseConstants.APIHeaderKeys.key)
        request.addValue(ParseConstants.QueryItemValues.contentTypeValue, forHTTPHeaderField: ParseConstants.QueryItemKeys.contentType)
        
        // Make the request
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPUT(nil, NSError(domain: "Parse Client (taskForPOSTMethod)", code: 1, userInfo: userInfo))
            }
            guard (error==nil) else {
                sendError("There was an error with your request: \(String(describing: error))")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPUT)
        }
        
        task.resume()
        return task

}
    
    // Convert Data into JSON
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    //Create a URL from parameters
    private func parseURLFromParameters(_ withPathExtension: String, parameters: [String:AnyObject]? = nil, parameterKey: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = ParseConstants.URL.ApiScheme
        components.host = ParseConstants.URL.ApiHost
        components.path = ParseConstants.URL.ApiPath + (withPathExtension)
        components.queryItems = [URLQueryItem]()
        
        if let key = parameterKey {
            components.path = components.path+"/"+key
        }
        if let parameter = parameters {
            for (key, value) in parameter {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.url!
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
        
    }
}
