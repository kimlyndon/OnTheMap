//
//  StudentDataSource.swift
//  On The Map
//
//  Created by Kim Lyndon on 11/7/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import Foundation

class StudentDataSource: NSObject {
    
    static let sharedInstance = StudentDataSource()
   
    var arrayOfStudentLocations = [StudentInformation]()
   
  
        }

//Per Code Review, use dispatch_once for shared instance.

    



