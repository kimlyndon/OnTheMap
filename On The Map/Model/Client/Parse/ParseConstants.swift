//
//  ParseConstants.swift
//  On The Map
//
//  Created by Kim Lyndon on 9/11/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import Foundation

struct ParseConstants {
    static let BaseURL: String = "https://parse.udacity.com/parse/classes/StudentLocation"
    static let AppID: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAblr"
    static let ApiKey: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
}

struct JSONResponseKeys {
    static let objectId: String = "objectId"
    static let uniqueKey: String = "uniqueKey"
    static let firstName: String = "firstName"
    static let lastName: String = "lastName"
    static let mapString: String = "mapString"
    static let mediaURL: String = "mediaURL"
    static let latitude: String = "latitude"
    static let longitude: String = "longitude"
    static let createdAt: String = "createdAt"
    static let updatedAt: String = "updatedAt"
    static let error: String = "error"
    static let results: String = "results"
}
