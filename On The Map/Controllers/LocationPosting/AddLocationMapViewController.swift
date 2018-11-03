//
//  AddLocationMapViewController.swift
//  On The Map
//
//  Created by Kim Lyndon on 10/25/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class AddLocationMapViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    
    //MARK: Properties
    // Per forum: Create blank properties in order to allow "AddLocationViewController" to send over data.
    var newLocation = StudentInformation.NewUserLocation.mapString
    var newURL = StudentInformation.NewUserLocation.mediaURL
    var newLatitude = StudentInformation.NewUserLocation.latitude
    var newLongitude = StudentInformation.NewUserLocation.longitude
    var userObjectId = StudentInformation.UserData.objectId
    
    var coordinates = [CLLocationCoordinate2D]() {
        didSet {
            
            //Update the pins (no duplicates)
            for (_, coordinate) in self.coordinates.enumerated() {
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                
                //Display name and url link
                annotation.title = newLocation
                annotation.subtitle = newURL
                
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let location = userNewLocationData()
        
        //Create an MKPointAnnotation for each dictionary in "locations."
        var annotations = [MKPointAnnotation]()
        
        for item in location {
            let lat = CLLocationDegrees(item["latitude"] as! Double)
            let long = CLLocationDegrees(item["longitude"] as! Double)
            
            // Use above to create CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = item["firstName"] as! String
            let last = item["lastName"] as! String
            let mediaURL = item["mediaURL"] as! String
            
            //Create the annotation coordinate with title and subtitle.
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            //Place in array of annotations:
            annotations.append(annotation)
        }
        
        //Mentor: "When the array is complete, we add the annotations to the map. There is only one item in the array: User's new location."
        self.mapView.addAnnotation(annotations as! MKAnnotation)
        
        let initialLocation = CLLocation(latitude: newLatitude, longitude: newLongitude)
        
        //From an example on forum: Calling the helper method to zoom into 'initialLocation' on startup.
        centerMapOnLocation(location: initialLocation)
    }
    
    func userNewLocationData() -> [[String : Any]] {
        return [
            [
            "createdAt" : "",
            "firstName" : StudentInformation.UserData.firstName,
            "lastName" : StudentInformation.UserData.lastName,
            "latitude" : StudentInformation.NewUserLocation.latitude,
            "longitude" : StudentInformation.NewUserLocation.longitude,
            "mapString" : StudentInformation.NewUserLocation.mapString,
            "mediaURL" : StudentInformation.NewUserLocation.mediaURL,
            "objectId" : "",
            "uniqueKey" : StudentInformation.UserData.uniqueKey,
            "updatedAt" : ""
            ]
        ]
    }
    
    //Specify the rectangular region to display for correct zoom level.
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    //MARK: MKMapViewDelegate (right callout accessory view).
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    //Open the system browser to specified URL in subtitle when tapped.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let url = view.annotation?.subtitle! {
                
                app.open(URL(string: url)!, options: [:], completionHandler: { (success)
                    in
                    if !success {
                        self.createAlert(title: "Invalid URL", message: "Could not open URL")
                    }
                })
            }
        } else {
            createAlert(title: "Error", message: "Could not segue to web browser. Check to see if URL is valid")
        }
    }
    
    //MARK: Actions
    @IBAction func finishButtonTapped(_ sender: UIButton) {
        finishButton.isEnabled = false
        
        //Get Student's Data
        if userObjectId.isEmpty {
            callPostToStudentLocation()
            
        } else {
        //User already exists (PUT)
            callPutToStudentLocation()
        }
    }
    
    //MARK: Methods
    func callPostToStudentLocation() {
       ParseClient.sharedInstance().postAStudentLocation(newUserMapString: newLocation, newUserMediaURL: newURL, newUserLatitude: newLatitude, newUserLongitude: newLongitude, completionHandlerForLocationPOST: { (success, errorString) in
            
            guard (success == true) else {
                // display the errorString using createAlert
                print("Unsuccessful in POSTing user location: \(errorString)")
                performUIUpdatesOnMain {
                    self.createAlert(title: "Error", message: "Unable to add new location. The Internet connection appears to be offline.")
                }
                return
            }
           print("Successfully POSTed user location.")
            
            ParseClient.sharedInstance().getALocation() { (success, errorString) in
                guard (success == true) else {
                    print("Unsuccessful in obtaining A Student Location from Parse: \(errorString)")
                    performUIUpdatesOnMain {
            
                        self.createAlert(title: "Error", message: "Failure to download user location data.")
                    }
                    return
                }
                print("Successfully obtained Student Location data from Parse")
                print("objectID: \(StudentInformation.UserData.objectId)")
                print("Student AccountKey: \(UdacityClient.sharedInstance().accountKey)")
                
                
                // MARK: Get 100 student locations from Parse
                ParseClient.sharedInstance().getLocationsRequest() { (success, errorString) in
                    
                    guard (success == true) else {
                    
                        print("Unsuccessful in obtaining Student Locations from Parse: \(errorString)")
                        performUIUpdatesOnMain {
                            self.createAlert(title: "Error", message: "Failure to download student locations data.")
                        }
                        return
                    }
                    print("Successfully obtained Student Locations data from Parse")
                    
                    // After all are successful, completeLogin
                    self.dismiss(animated: true, completion: nil)
                    
                }
            }
        })
    }

    func callPutToStudentLocation() {
        ParseClient.sharedInstance().putAStudentLocation(newUserMapString: newLocation, newUserMediaURL: newURL, newUserLatitude: newLatitude, newUserLongitude: newLongitude, completionHandlerForLocationPUT: { (success, errorString) in
            
            guard (success == true) else {
                
                print("callPutToStudentLocation: Unsuccessful in obtaining User Name from Udacity Public User Data: \(errorString)")
                performUIUpdatesOnMain {
            
                    self.createAlert(title: "Error", message: "Unable to add new location. The Internet connection appears to be offline.")
                }
                return
            }
            
            print("Successfully PUT user location.")
            
            ParseClient.sharedInstance().getALocation() { (success, errorString) in
                guard (success == true) else {
                    
                    print("Unsuccessful in obtaining A Student Location from Parse: \(errorString)")
                    performUIUpdatesOnMain {
                     
                        self.createAlert(title: "Error", message: "Failure to download user location data.")
                    }
                    return
                }
                print("Successfully obtained Student Location data from Parse")
                print("objectID: \(StudentInformation.UserData.objectId)")
                
                
                // MARK: Get 100 student locations from Parse
                ParseClient.sharedInstance().getLocationsRequest() { (success, errorString) in
                    
                    guard (success == true) else {
                      
                        print("Unsuccessful in obtaining Student Locations from Parse: \(errorString)")
                        performUIUpdatesOnMain {
                            
                            self.createAlert(title: "Error", message: "Failure to download student locations data.")
                        }
                        return
                    }
                    print("Successfully obtained Student Locations data from Parse")
                    
                    // After all are successful, completeLogin
                    self.dismiss(animated: true, completion: nil)
                    
                }
            }
        })
    }
    
}



