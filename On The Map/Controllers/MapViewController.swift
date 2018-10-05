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
    
    @IBOutlet weak var mapView: MKMapView!
    //Note from Phuc Tran: Use this function to be able to click on a marker and open the link. Ask about the error "Use of unresolved identifier MiscUtils"
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let link = view.annotation?.subtitle {
            MiscUtils.openExternalLink(link)
        }
    }
    
    
}

