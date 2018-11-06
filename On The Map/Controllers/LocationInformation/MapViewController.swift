//
//  MapViewController.swift
//  On The Map
//
//  Created by Kim Lyndon on 9/13/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var annotations = [MKPointAnnotation]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("MapViewController: viewWillAppear and calls updatedMapView()")
        updateMapView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    func updateMapView() {
        
        performUIUpdatesOnMain {self.displayUpdatedAnnotations()}
    }
    
    func displayUpdatedAnnotations() {
        
        // Populate the mapView with 100 pins:
        self.mapView.removeAnnotations(mapView.annotations)
        
        // We will create an MKPointAnnotation for each dictionary in "locations".
        var newAnnotations = [MKPointAnnotation]()
        
        
        // This is an array of studentLocations (struct StudentInformation)
        for student in arrayOfStudentLocations {
    
           
            let lat = CLLocationDegrees(student.latitude ?? 0)
            let long = CLLocationDegrees(student.longitude ?? 0)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            // set constants to the StudentLocation data to be displayed in each pin
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL
            
            // Create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(String(describing: first)) \(String(describing: last))"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            newAnnotations.append(annotation)
        }
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(newAnnotations)
    }
    
    // removes current annotations and re-inserts annotations
    func updateAnnotations() {
        
        print("UpdateMapView: Step 4 - call updateAnnotations")
    
        var annotations = [MKPointAnnotation]()
        
        for student in arrayOfStudentLocations {
           
            let lat = CLLocationDegrees(student.latitude ?? 0)
            let long = CLLocationDegrees(student.longitude ?? 0)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            // set constants to the StudentLocation data to be displayed in each pin
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(String(describing: first)) \(String(describing: last))"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
    }
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    let locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    // MARK: - MKMapViewDelegate
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
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let url = view.annotation?.subtitle! {
                
                // print: true or false
                print("verifyURL: \(verifyUrl(urlString: url))")
                
                if verifyUrl(urlString: url) == true {
                    app.open(URL(string:url)!)
                } else {
                    performUIUpdatesOnMain {
                        self.createAlert(title: "Invalid URL", message: "Could not open URL")
                    }
                }
            }
        } 
    }
}


