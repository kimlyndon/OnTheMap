//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Kim Lyndon on 10/30/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import Foundation

extension ParseClient {
    
   
    
    //MARK: GET Convenience Methods (extract first and last name from public  user data)
    
    func getALocation(completionHandlerForGETALocation: @escaping (_ success: Bool, _ error: String) -> Void) {
        
        taskForGetALocation() { (data, error) in
            
            guard (error == nil) else {
                print("Error from taskForGETALocation: \(String(describing: error?.localizedDescription))")
                return
            }
            
            guard let data = data else {
                print("Error from taskForGETALocation: \(String(describing: error?.localizedDescription))")
                completionHandlerForGETALocation(false, "No raw JSON data available.")
                return
            }
            
            var parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
            } catch {
                print("taskForGETALocation failed to parse data.")
                completionHandlerForGETALocation(false, "Failed to parse data.")
                return
            }
            
            print("USER LOCATION PARSED RESULT: \(String(describing: parsedResult))")
            
            // Extract 'results' Array
            guard let results = parsedResult["results"] as? [[String:AnyObject]] else {
                completionHandlerForGETALocation(false, "No valid results")
                print("ERROR: Could not parse values from the 'results' key.")
                return
            }
            
            guard !(results.isEmpty) else {
                //Populate user student location with objectId
                StudentInformation.UserData.objectId = ""
                print("USER LOCATION 'results' value should be an empty array ([]): \(results)")
                print("UserLocation.UserData.objectId set == to \"\"")
                completionHandlerForGETALocation(true, "")
                return
            }
            
            //objectId exists so store it! (We already have first & last name & uniqueKeyfrom API)
            print("USER LOCATION RESULT (objectId exists): \(results)")
            
            //MARK: KEEP - GUARD: objectId
            guard let objectId = results[0]["objectId"] as? String else {
                print("taskForGETALocation(): Could not parse 'objectId' from 'results[0]'")
                return
            }
            
            StudentInformation.UserData.objectId = objectId
            print("results[0] parsed 'objectId: \(StudentInformation.UserData.objectId)")
            
            //MARK: KEEP - GUARD: mapString
            guard let mapString = results[0]["mapString"] as? String else {
                print("taskForGETALocation(): Could not parse 'mapString' from 'results[0]")
                return
            }
            
            StudentInformation.UserData.mapString = mapString
            print("results[0] parsed 'mapString: \(StudentInformation.UserData.mapString)")
            
            //  MARK: KEEP - GUARD: mediaURL
            guard let mediaURL = results[0]["mediaURL"] as? String else {
                print("taskForGETALocation(): Could not parse 'mediaURL' from 'results[0]")
                return
            }
            
            StudentInformation.UserData.mediaURL = mediaURL
            print("results[0] parsed 'mediaURL: \(StudentInformation.UserData.mediaURL)")
            
            //  MARK: KEEP - GUARD: latitude
            guard let latitude = results[0]["latitude"] as? Double else {
                print("taskForGETALocation(): Could not parse 'latitude' from 'results[0]")
                return
            }
            
            StudentInformation.UserData.latitude = latitude
            print("results[0] parsed 'latitude: \(StudentInformation.UserData.latitude)")
            
            //  MARK: KEEP - GUARD: longitude
            guard let longitude = results[0]["longitude"] as? Double else {
                print("taskForGETALocation(): Could not parse 'longitude' from 'results[0]")
                return
            }
            
            StudentInformation.UserData.longitude = longitude
            print("results[0] parsed 'longitude: \(StudentInformation.UserData.longitude)")
            
            // this is the only completion handler that has data set to true
            completionHandlerForGETALocation(true, "")
        }
        
       
    }
    
    //MARK: GET Convenience method for extracting multiple names from data.
    func getLocationsRequest(completionHandlerForGETLocationsRequest: @escaping (_ success:Bool, _ error:String)->Void) {
        
        let _ = taskForGETLocationsRequest() { (data, error) in
            print("errorString in getStudentLocations closure: \(String(describing: error))")
            print("data: \(String(describing: data))")
            
            guard let data = data else {
                print("Error from taskForGETLocationsRequest: \(String(describing: error?.localizedDescription))")
                completionHandlerForGETLocationsRequest(false, "No raw JSON data available.")
                return
            }
            
            var parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
            } catch {
                print("taskForGETLocationsRequest: Failed to parse data")
                completionHandlerForGETLocationsRequest(false, "Failed to parse data.")
                return
            }
            
            // (2) extract 'results' ArrayOfDictionary
            guard let results = parsedResult["results"] as? [[String:AnyObject]] else {
                completionHandlerForGETLocationsRequest(false, "No valid 'results' dictionary in parsed JSON data")
                print("ERROR: Could not parse values from the 'results' key for func getLocationsRequest()")
                return
            }
            
            print("")
            print("")
            print("")
            print("100 Student Locations")
            print("")
            print(results)
            print("")
            print("")
            print("")
            
            var arrayOfLocationsDictionaries = results
            
            //Forum Mentor: Check if a user location exists, if yes, add it to the 100 student locations. If not, do not add.
            guard StudentInformation.UserData.objectId != "" else {
                
                // objectId == "", ignore user location and input data retrieved into the array.
               // print("User's objectId does NOT exist [\(StudentInformation.UserData.objectId)], store 100 student locations.")
                
                StudentDataSource.sharedInstance().arrayOfStudentLocations = StudentInformation.studentInformationFromResults(arrayOfLocationsDictionaries)
                completionHandlerForGETLocationsRequest(true, "")
                return
            }
            
            // StudentInformation.UserData.objectId exists, append 1 userLocationDictionary to 100 locations arrayOfStudentLocations:
            print("User's objectId DOES exist [\(StudentInformation.UserData.objectId)]. Append Existing User Location to top of 100 Student Locations")
            arrayOfLocationsDictionaries.insert(StudentInformation.userLocationDictionary, at: 0)
            
            //  MARK: Store 101 Student locations (includes 1 User Location)
            
           StudentDataSource.sharedInstance().arrayOfStudentLocations = StudentInformation.studentInformationFromResults(arrayOfLocationsDictionaries)
            
            print("")
            print("arrayOfStudentLocations")
            print(StudentDataSource.sharedInstance().arrayOfStudentLocations)
            print("")
            
            // Only completionHander that sets 'data' to 'true'
            completionHandlerForGETLocationsRequest(true, "")
        }
    }
    
    //MARK: POST Convenience Methods
    func postAStudentLocation(newUserMapString: String, newUserMediaURL: String, newUserLatitude: Double, newUserLongitude: Double, completionHandlerForLocationPOST: @escaping (_ success:Bool, _ error:String) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        
        // backslash before the double quote you want to insert in the String
        let jsonBody = "{\"uniqueKey\": \"\(StudentInformation.UserData.uniqueKey)\", \"firstName\": \"\(StudentInformation.UserData.firstName)\", \"lastName\": \"\(StudentInformation.UserData.lastName)\",\"mapString\":  \"\(newUserMapString)\", \"mediaURL\": \"\(newUserMediaURL)\",\"latitude\": \(newUserLatitude), \"longitude\":  \(newUserLongitude)}"
        
        print("jsonBody for POST: \(jsonBody)")
        
        /* 2. Make the request */
        let _ = taskForPOSTAStudentLocation(jsonBody: jsonBody) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForLocationPOST(false, "Error: Could not POST new user location")
                print(error)
                
                print("POST Error?: \(error)")
            } else {
                completionHandlerForLocationPOST(true, "Successful POST")
            }
        }
    }
    
    // MARK: PUT Convenience Methods
    func putAStudentLocation(newUserMapString: String, newUserMediaURL: String, newUserLatitude: Double, newUserLongitude: Double, completionHandlerForLocationPUT: @escaping (_ success:Bool, _ error:String) -> Void) {
        
        // backslash before the double quote you want to insert in the String
        let jsonBody = "{\"uniqueKey\": \"\(StudentInformation.UserData.uniqueKey)\", \"firstName\": \"\(StudentInformation.UserData.firstName)\", \"lastName\": \"\(StudentInformation.UserData.lastName)\",\"mapString\":  \"\(newUserMapString)\", \"mediaURL\": \"\(newUserMediaURL)\",\"latitude\": \(newUserLatitude), \"longitude\":  \(newUserLongitude)}"
        
        print("jsonBody for PUT: \(jsonBody)")
        
        /* Make the request */
        let _ = updateStudentLocation(jsonBody: jsonBody) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForLocationPUT(false, "Error: Could not PUT new user location")
                print(error)
                print("PUT Error?: \(error)")
            } else {
                print("Are we getting here?")
                
                completionHandlerForLocationPUT(true, "Successful PUT")
                
            }
        }
    }
}
