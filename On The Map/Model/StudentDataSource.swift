//
//  StudentDataSource.swift
//  On The Map
//
//  Created by Kim Lyndon on 11/7/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import Foundation

class StudentDataSource: NSObject {
    
    
    var arrayOfStudentLocations = [StudentInformation]()
   
    class func sharedInstance() -> StudentDataSource {
        struct Singleton {
            static var sharedInstance = StudentDataSource()
        }
        return Singleton.sharedInstance
    }
}
    


