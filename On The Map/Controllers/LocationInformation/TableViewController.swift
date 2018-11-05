//
//  TableViewController.swift
//  On The Map
//
//  Created by Kim Lyndon on 11/2/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    //MARK: Properties
    var studentLocations = arrayOfStudentLocations
    
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
        let studentLocation = studentLocations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! UITableViewCell
        
        //Set cell defaults
        let first = studentLocation.firstName
        let last = studentLocation.lastName
        let mediaURL = studentLocation.mediaURL
        cell.textLabel!.text = "\(String(describing: first)) \(String(describing: last))"
        cell.imageView!.image = UIImage(named: "icon_pin")
        cell.detailTextLabel!.text = mediaURL
        cell.imageView!.contentMode = UIViewContentMode.scaleAspectFit
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        //Open mediaURL
        let app = UIApplication.shared
        let url = studentLocations[indexPath.row].mediaURL
        
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
