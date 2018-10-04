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
    
    init?(dictionary: [String: AnyObject]) {
        
        self.objectId = dictionary[ParseConstants.JSONResponseKeys.ObjectId] as? String
        self.uniqueKey = dictionary[ParseConstants.JSONResponseKeys.UniqueKey] as? String
        self.firstName = dictionary[ParseConstants.JSONResponseKeys.FirstName] as? String
        self.lastName = dictionary[ParseConstants.JSONResponseKeys.LastName] as? String
        self.latitude = dictionary[ParseConstants.JSONResponseKeys.Latitude] as? Double
        self.longitude = dictionary[ParseConstants.JSONResponseKeys.Longitude] as? Double
        self.mapString = dictionary[ParseConstants.JSONResponseKeys.MapString] as? String
        self.mediaURL = dictionary[ParseConstants.JSONResponseKeys.MediaURL] as? String
        self.createdAt = dictionary[ParseConstants.JSONResponseKeys.CreatedAt] as? String
        self.updatedAt = dictionary[ParseConstants.JSONResponseKeys.UpdatedAt] as? String
        
    }
    
    static func studentInformationFromResults(_ results: [[String: AnyObject]]) -> [StudentInformation] {
        
        var studentLocations = [StudentInformation]()
        
        for result in results {
            studentLocations.append(StudentInformation(dictionary: result)!)
        }
        
        return studentLocations
    }
}
