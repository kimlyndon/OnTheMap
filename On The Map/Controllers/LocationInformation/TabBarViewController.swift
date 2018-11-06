//
//  TabBarViewController.swift
//  On The Map
//
//  Created by Kim Lyndon on 11/2/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    @IBOutlet weak var logoutBarButton: UIBarButtonItem!
    @IBOutlet weak var refreshBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
}
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshThings()
    
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
        
        UdacityClient.sharedInstance().taskForDELETELogoutMethod()
        
        performUIUpdatesOnMain {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func refreshBarButtonTapped(_ sender: UIBarButtonItem) {
        refreshThings()
    }
    
    func refreshThings() {
        print("refresh bar button pressed")
        
        
        //Create constants to prepare for refreshing the two view controllers
        let mapViewController = self.viewControllers?[0] as! MapViewController
        let tableViewController = self.viewControllers![1] as! TableViewController
        
        //Get 100 student locations from Parse
        ParseClient.sharedInstance().getLocationsRequest() { (success, errorString) in
            
            guard (success == true) else {
                print("Unsuccessful in obtaining student locations from Parse: \(errorString)")
                
                performUIUpdatesOnMain {
                    self.createAlert(title: "Error", message: "Failure to download student location data.")
                }
                
                return
            }
            
            performUIUpdatesOnMain {
                //Update UI in both MapVC and TableVC
                print("RefreshUI")
                mapViewController.displayUpdatedAnnotations()
                tableViewController.refreshTableView()
            }
        }
 
    }
    
    @IBAction func addBarButtonTapped(_ sender: Any) {
        //Segues to AddLocationViewController
        
        }

    
    //MARK: Navigation (Per Mentor:)
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "AddButtonSegue" {
            print("Add Segue: was the click button clicked?")
            
            // if no prior user location posted (mapString should be "")
            if StudentInformation.UserData.objectId == "" {
                print("User has not posted their location yet.")
                print("User Object ID: \(StudentInformation.UserData.objectId)")
                
                // performSegue(withIdentifier: "AddButtonSegue", sender: nil)
                
                performUIUpdatesOnMain {
                    let controller = self.storyboard!.instantiateViewController(withIdentifier: "AddLocationNavigationController") as! UINavigationController
                    self.present(controller, animated: true, completion: nil)
                }
                return
            } else {
                // mapString contains data, so the user has already posted a location
                print("User has already posted a location")
                print("User Object ID: \(StudentInformation.UserData.objectId)")
                
                // display the errorString using createAlert
                createTwoButtonAlert()
                return
            }
        }
    }
    
    func createTwoButtonAlert() {
        
        let alertController = UIAlertController(title: "Warning", message: "User \(StudentInformation.UserData.firstName) \(StudentInformation.UserData.lastName) has already posted a Student Location. Would you like to overwrite the location of '\(StudentInformation.UserData.mapString)'?", preferredStyle: .alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped");
            
            performUIUpdatesOnMain {
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "AddLocationNavigationController") as! UINavigationController
                self.present(controller, animated: true, completion: nil)
            }
            return
        }
        
        alertController.addAction(OKAction)
        
        // Create Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button tapped");
        }
        alertController.addAction(cancelAction)
        
        // Present Dialog message
        self.present(alertController, animated: true, completion:nil)
    }
    
    
}

