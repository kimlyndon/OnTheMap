//
//  StudentInformation.swift
//  On The Map
//
//  Created by Kim Lyndon on 9/13/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    let objectId : String?
    let firstName: String?
    let lastName : String?
    let latitude : Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL : String?
    let uniqueKey: String?
    let updatedAt: String?
    let createdAt: String?
    
    static var studentArray = [StudentInformation]()
    init(fromDictionary dictionary: [String:AnyObject]) {
        if let firstName = dictionary[ParseConstants.JSONResponseKeys.firstName] as? String {
            self.firstName = firstName
        } else {
            self.firstName = nil
            
        }
        
        if let lastName = dictionary[ParseConstants.JSONResponseKeys.lastName] as? String {
            self.lastName = lastName
        } else {
            self.lastName = nil
            
        }
        
        if let latitude = dictionary[ParseConstants.JSONResponseKeys.latitude] as? Double {
            self.latitude = latitude
        } else {
            self.latitude = nil
            
        }
        
        if let longitude = dictionary[ParseConstants.JSONResponseKeys.longitude] as? Double {
            self.longitude = longitude
        } else {
            self.longitude = nil
            
        }
        
        if let mapString = dictionary[ParseConstants.JSONResponseKeys.mapString] as? String {
            self.mapString = mapString
        } else {
            self.mapString = nil
            
        }
        
        if let mediaURL = dictionary[ParseConstants.JSONResponseKeys.mapString] as? String {
            self.mediaURL = mediaURL
        } else {
            self.mediaURL = nil
            
        }
        
        if let objectId = dictionary[ParseConstants.JSONResponseKeys.objectId] as? String {
            self.objectId = objectId
        } else {
            self.objectId = nil
            
        }
        
        if let uniqueKey = dictionary[ParseConstants.JSONResponseKeys.uniqueKey] as? String {
            self.uniqueKey = uniqueKey
        } else {
            self.uniqueKey = nil
            
        }
        
        if let updatedAt = dictionary[ParseConstants.JSONResponseKeys.updatedAt] as? String {
            self.updatedAt = updatedAt
        } else {
            self.updatedAt = nil
            
        }
        
        if let createdAt = dictionary[ParseConstants.JSONResponseKeys.createdAt] as? String {
            self.createdAt = createdAt
        } else {
            self.createdAt = nil
            
        }
    }
}
