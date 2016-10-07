//
//  ViewController.swift
//  Memorable Places
//
//  Created by Lovish Dogra on 15/03/16.
//  Copyright © 2016 Lovish Dogra. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var manager: CLLocationManager!
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        UserDefaults.standard.set(places, forKey: "places")
        
        if activePlace == -1 {
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        }
        else{
            let latitude = NSString(string: places[activePlace]["lat"]!).doubleValue
            let longitude = NSString(string: places[activePlace]["long"]!).doubleValue
            let latDelta:CLLocationDegrees = 0.01
            let longDelta:CLLocationDegrees = 0.01
            let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
            let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)

            mapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = places[activePlace]["name"]
            self.mapView.addAnnotation(annotation)
        }
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.action(_:)))
        uilpgr.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(uilpgr)
    }
    
    func action(_ gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            let touchPoint = gestureRecognizer.location(in: self.mapView)
            let newCoordinate = mapView.convert(touchPoint, toCoordinateFrom: self.mapView )
            
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                var title = ""
                if(error == nil){
                    if let p:CLPlacemark = CLPlacemark(placemark: (placemarks?[0])! as CLPlacemark) {
                        var subThoroughfare:String = ""
                        var thoroughfare:String = ""
                        
                        if p.subThoroughfare != nil {
                            subThoroughfare = p.subThoroughfare!
                        }
                        if p.thoroughfare != nil {
                            thoroughfare = p.thoroughfare!
                        }
                        title = "\(subThoroughfare) \(thoroughfare)"
                    }
                }
                if title.trimmingCharacters(in: CharacterSet.whitespaces) == "" {
                    title = "Added \(Date())"
                }
                places.append(["name":title, "lat":"\(newCoordinate.latitude)", "long":"\(newCoordinate.longitude)"])
                print(places)
                let annotation = MKPointAnnotation()
                annotation.coordinate = newCoordinate
                annotation.title = title
                self.mapView.addAnnotation(annotation)
            })
        }
    }
    
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

