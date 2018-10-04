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
    
    // MARK: Shared Instance
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
    
    //MARK: GET
    func taskForParseRequest(requestType: String, optionalParameters: [String: AnyObject], pathExtension: String?, addContentType: Bool, httpBody: String?, completionHandlerForParseRequest: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: parseURLFromParameters(optionalParameters, method: ParseConstants.Methods.studentLocation, withPathExtension: pathExtension))
        request.httpMethod = requestType
        request.httpMethod = requestType
        request.addValue(ParseConstants.APIHeaderValues.AppID, forHTTPHeaderField: ParseConstants.APIHeaderKeys.ID)
        request.addValue(ParseConstants.APIHeaderValues.ApiKey, forHTTPHeaderField: ParseConstants.APIHeaderKeys.Key)
        
        if let httpBody = httpBody {
            request.httpBody = httpBody.data(using: String.Encoding.utf8)
        }
        
        if addContentType {
            request.addValue(ParseConstants.QueryItemValues.contentTypeValue, forHTTPHeaderField: ParseConstants.QueryItemKeys.contentType)
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForParseRequest(nil, NSError(domain: "taskForParseRequest", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
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
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForParseRequest)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
        
    }
    //MARK: POST
    func postStudentLocation(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaUrl: String, latitude: Double, longitude: Double, completionHandlerForPostStudentLocation: @escaping ( _ createdAt: String?, _ objectId: String?, _ error: NSError?) -> Void) {
        
        let parameters = [String: AnyObject]()
        
        let httpBody = "{\"\(ParseConstants.StudentLocationItem.uniqueKey)\": \"\(uniqueKey)\", \"\(ParseConstants.StudentLocationItem.firstName)\": \"\(firstName)\", \"\(ParseConstants.StudentLocationItem.lastName)\": \"\(lastName)\",\"\(ParseConstants.StudentLocationItem.mapString)\": \"\(mapString)\", \"\(ParseConstants.StudentLocationItem.mediaURL)\": \"\(mediaUrl)\",\"\(ParseConstants.StudentLocationItem.latitude)\": \(latitude), \"\(ParseConstants.StudentLocationItem.longitude)\": \(longitude)}"
        
        let _ = taskForParseRequest(requestType: ParseConstants.URLRequest.postMethod, optionalParameters: parameters, pathExtension: nil, addContentType: true, httpBody: httpBody) { (result, error) in
            
            guard (error == nil) else {
                completionHandlerForPostStudentLocation(nil, nil, error)
                return
            }
            
            if let createdAt = result?[ParseConstants.JSONResponseKeys.CreatedAt], let objectId = result?[ParseConstants.JSONResponseKeys.ObjectId] {
                completionHandlerForPostStudentLocation(createdAt as! String?, objectId as! String?, nil)
            } else {
                completionHandlerForPostStudentLocation(nil, nil, NSError(domain: "postStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postStudentLocation"]))
            }
        }
    }
    
    //MARK: PUT
    func updateStudentLocation(objectId: String, uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaUrl: String, latitude: Double, longitude: Double, completionHandlerForUpdateStudentLocation: @escaping ( _ updatedAt: String?, _ error: NSError?) -> Void) {
        
        let parameters = [String: AnyObject]()
        
        let httpBody = "{\"\(ParseConstants.StudentLocationItem.uniqueKey)\": \"\(uniqueKey)\", \"\(ParseConstants.StudentLocationItem.firstName)\": \"\(firstName)\", \"\(ParseConstants.StudentLocationItem.lastName)\": \"\(lastName)\",\"\(ParseConstants.StudentLocationItem.mapString)\": \"\(mapString)\", \"\(ParseConstants.StudentLocationItem.mediaURL)\": \"\(mediaUrl)\",\"\(ParseConstants.StudentLocationItem.latitude)\": \(latitude), \"\(ParseConstants.StudentLocationItem.longitude)\": \(longitude)}"
        
        let pathExtension = "/\(objectId)"
        
        let _ = taskForParseRequest(requestType: ParseConstants.URLRequest.putMethod, optionalParameters: parameters, pathExtension: pathExtension, addContentType: true, httpBody: httpBody) { (result, error) in
            
            guard (error == nil) else {
                completionHandlerForUpdateStudentLocation(nil, error)
                return
            }
            
            if let updatedAt = result?[ParseConstants.JSONResponseKeys.UpdatedAt] {
                completionHandlerForUpdateStudentLocation(updatedAt as! String?, nil)
            } else {
                completionHandlerForUpdateStudentLocation(nil, NSError(domain: "updateStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse updateStudentLocation"]))
            }
        }
    }
    
    //Create a URL from parameters
    private func parseURLFromParameters(_ parameters: [String:AnyObject], method: String? = nil, withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = ParseConstants.URL.ApiScheme
        components.host = ParseConstants.URL.ApiHost
        components.path = ParseConstants.URL.ApiPath + (method ?? "") + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        
        return components.url!
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
    
   
   
        
    }


