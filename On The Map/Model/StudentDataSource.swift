//
//  StudentDataSource.swift
//  On The Map
//
//  Created by Kim Lyndon on 11/7/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import Foundation

class StudentDataSource: NSObject {
    
    static let shradeInstance = StudentDataSource()
    
    var arrayOfStudentLocations = [StudentInformation]()
    
    private override init() {}
    
    func updateModel(_ studentArray : [[String: AnyObject]]) {
        
        self.arrayOfStudentLocations.removeAll()
        
        for dictionary in studentArray {
            
            let student = StudentInformation.init(dictionary: dictionary)
            arrayOfStudentLocations.append(student!)
        }
    }
}
