//
//  MapViewController.swift
//  On The Map
//
//  Created by Kim Lyndon on 9/13/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//
import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UINavigationControllerDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var studentLocations = [StudentInformation]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
       super.viewDidLoad()
        self.navigationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.removeAnnotation(mapView?.annotations as! MKAnnotation)
        mapView.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(selectorMethod), name: NSNotification.Name(rawValue: "SuccessNotification"), object: nil)
        
        studentLocations = appDelegate.studentLocations
        
        var annotations = [MKPointAnnotation]()
        
        var lat: Double
        var long: Double
        var first: String
        var last: String
        
        for dictionary in studentLocations {
            lat = 0
            long = 0
            first = ""
            last = ""
            
            if let _ = dictionary.latitude {
                lat = dictionary.latitude!
                
            } else {
                lat = 0
            }
            if let _ = dictionary.longitude {
                long = dictionary.longitude!
                
            } else {
                long = 0
            }
            lat = CLLocationDegrees(lat)
            long = CLLocationDegrees(long)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            if let _ = dictionary.firstName {
                first =  dictionary.firstName!
            } else {
                last = ""
            }
            if let _ = dictionary.lastName {
                last = dictionary.lastName!
            } else {
                last = ""
            }
            
            let mediaURL = dictionary.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
            
        }
        
        performUIUpdatesOnMain {
            self.mapView.addAnnotations(annotations)
            
        }
    }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let reuseID = "pin"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
            
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
                pinView!.canShowCallout = true
                pinView!.pinTintColor = .red
                pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {
                pinView!.annotation = annotation
            }
            
            return pinView
        }
        
    //Note from Phuc Tran: Use this function to be able to click on a marker and open the link.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let url = URL(string: ((view.annotation?.subtitle)!)!) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    let alertController = UIAlertController(title: "Error", message: "Invalid link", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let dismissAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.destructive) {
                        (result : UIAlertAction) -> Void in
                        
                    }
                    
                    alertController.addAction(dismissAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
     func selectorMethod() {
            
            ParseClient.sharedInstance().taskForGETLocationsRequest() {(data, error) in
                if error == nil {
                    if let data = data {
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.studentLocations = []
                        appDelegate.studentLocations = data
                    }
                }
                performUIUpdatesOnMain {
                    self.mapView.reloadInputViews()
                }
                
            }
            NotificationCenter.default.removeObserver(self)
            
        }
    }
}
