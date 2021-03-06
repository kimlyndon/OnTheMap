//
//  TableViewController.swift
//  On The Map
//
//  Created by Kim Lyndon on 11/2/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import UIKit



class TableViewController: UITableViewController {

    //MARK: Outlets
    @IBOutlet weak var ListTableView: UITableView!
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        refreshTableView()
    }
    
    // Refresh table data
    func refreshTableView() {
        if let ListTableView = ListTableView {
            ListTableView.reloadData()
        }
    }
    
    
    //MARK: TableView delegate methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        // Get cell type
        let cellReuseIdentifier = "TableViewCell"
        let studentLocations = StudentDataSource.sharedInstance.arrayOfStudentLocations
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! UITableViewCell
        
        //Set cell defaults
        let first = studentLocations[indexPath.row].firstName
        let last = studentLocations[indexPath.row].lastName
        let mediaURL = studentLocations[indexPath.row].mediaURL
        cell.textLabel!.text = "\(first ?? "") \(last ?? "")"
        cell.imageView!.image = UIImage(named: "icon_pin")
        cell.detailTextLabel?.text = mediaURL
        cell.imageView!.contentMode = UIViewContentMode.scaleAspectFit
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentDataSource.sharedInstance.arrayOfStudentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        //Open mediaURL
        let app = UIApplication.shared
        let url = StudentDataSource.sharedInstance.arrayOfStudentLocations[indexPath.row].mediaURL
            
        
        print("verifyURL: \(verifyUrl(urlString: url))")
        
        if verifyUrl(urlString: url) == true {
            app.open(URL(string: url!)!)
        
        } else {
        
            performUIUpdatesOnMain {
                self.createAlert(title: "Invalid URL", message: "Could not open URL.")
            }
        }
    }
}

