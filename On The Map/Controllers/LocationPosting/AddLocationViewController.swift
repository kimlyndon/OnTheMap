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
    @IBOutlet weak var actInd: UIActivityIndicatorView!
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        actInd.hidesWhenStopped = true
    }
    
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
        actInd.startAnimating()
        
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
            
          /*  func showActivityIndicatory(uiView: UIView) {
                let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
                actInd.frame = CGRect(x:0.0, y:0.0, width: 40.0, height: 40.0);
                actInd.center = uiView.center
                actInd.hidesWhenStopped = true
                actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
                uiView.addSubview(actInd)
                actInd.startAnimating()
            }  */
            
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
    
    // MARK: Keyboard Methods
// Move the view up to accommodate keyboard.
    @objc override func keyboardWillShow(_ notification:Notification) {
        self.view.frame.origin.y =  getKeyboardHeight(notification) * -0.3
        
    }
    
    // move the view back down when the keyboard is dismissed
    @objc override func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y = 0
        
    }
    
    }
    


