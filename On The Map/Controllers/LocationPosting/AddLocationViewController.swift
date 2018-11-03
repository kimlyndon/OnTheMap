//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by Kim Lyndon on 10/24/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var enterLocationTextField: UITextField!
    @IBOutlet weak var enterURLTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    //MARK: Properties
    var keyboardOnScreen = false
    // Variables for new user coordinates passed
    var newLocation = ""
    var newURL = ""
    var newLatitude = 0.0
    var newLongitude = 0.0
    var coordinates = [CLLocationCoordinate2D]() {
        didSet {
            
            for (_, coordinate) in self.coordinates.enumerated() {
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
            }
        }
    }
    
    //MARK: Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        enableUI()
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //MARK: Actions
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        enterLocationTextField.text = ""
        enterURLTextField.text = ""
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationButtonTapped(_ sender: UIButton) {
        guard let location = enterLocationTextField.text, location != "" else {
            print("Location is empty")
            createAlert(title: "Error", message: "Please enter location")
            return
        }
        
        guard let url = enterURLTextField.text, url != "", url.hasPrefix("https://") else {
            print("URL is empty")
            createAlert(title: "Error", message: "Invalid URL. Please enter a URL that starts with 'https://'")
            return
        }
        
        self.disableUI()
        
        StudentInformation.NewUserLocation.mapString = location
        newLocation = location
        StudentInformation.NewUserLocation.mediaURL = url
        newURL = url
        
        getCoordinatesFromLocation(location: newLocation)
    }
    
    //MARK: Methods
    
    func getCoordinatesFromLocation(location: String) {
        print("getCoordinatesOfLocation called")
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(location) {
            (placemarks, error) in
            // No internet connection
            print("getCoordinatesFromLocation error \(String(describing: error))")
            
            guard (error == nil) else {
                print("Print Error: \(String(describing: error!.localizedDescription))")
                
                self.createAlert(title: "Error", message: "Could not calculate coordinates. Check your internet connection.")
                self.enableUI()
                return
            }
            
            let placemark = placemarks?.first
        
            guard let placemarkLatitude = placemark?.location?.coordinate.latitude else {
                print("Could not calculate latitude coordinate from geocodeAddressString")
                self.createAlert(title: "Error", message: "Could not calculate latitude coordinate. Re-try location.")
                self.enableUI()
                return
            }
            
            StudentInformation.NewUserLocation.latitude = placemarkLatitude
            
            guard let placemarkLongitude = placemark?.location?.coordinate.longitude else {
                print("Could not calculate longitude coordinate from geocodeAdressString")
                self.createAlert(title: "Error", message: "Could not calculate. Re-try location.")
                self.enableUI()
                return
            }
            
            StudentInformation.NewUserLocation.longitude = placemarkLongitude
            
            print("geCoordinatesOfLocation: Lat: \(StudentInformation.NewUserLocation.latitude), Lon: \(StudentInformation.NewUserLocation.longitude)")
            
            print("Call passDataToNextViewController")
            self.passDataToNextViewController()
        }
    }
    
    func passDataToNextViewController() {
        print("Confirmed")
        
        performUIUpdatesOnMain {
            
            print("Entering Segue")
            
            let addLocationMapVC = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationMapViewController") as! AddLocationMapViewController
            
            self.navigationController?.pushViewController(addLocationMapVC, animated: true)
        }
    }
}
