//
//  ViewController.swift
//  Memorable Places
//
//  Created by Abhinav Jayanthy on 1/17/17.
//  Copyright © 2017 Abhinav Jayanthy. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet var map: MKMapView!
    
    var manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longPress(gestureRecognizer:)))
        uilpgr.minimumPressDuration = 2
        map.addGestureRecognizer(uilpgr)
        
        if activePlace == -1{
            
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
            
        }else{
            // get plce details on map
            
            if places.count > activePlace{
                if let name = places[activePlace]["name"]{
                    if let lat = places[activePlace]["lat"]{
                        if let long = places[activePlace]["long"]{
                            if let lattitude = Double(lat){
                                if let longitude = Double(long){
                                    
                                    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                    let coordinate = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
                                    let region = MKCoordinateRegion(center: coordinate, span: span)
                                    
                                    self.map.setRegion(region, animated: true)
                                    
                                    let annotation = MKPointAnnotation()
                                    annotation.title = name
                                    annotation.coordinate = coordinate
                                    self.map.addAnnotation(annotation)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func longPress(gestureRecognizer :UIGestureRecognizer)  {
        
        if gestureRecognizer.state == UIGestureRecognizerState.began{
            
            let touchPoint = gestureRecognizer.location(in: self.map)
            let newLocation = self.map.convert(touchPoint, toCoordinateFrom:self.map)
            let location = CLLocation(latitude: newLocation.latitude, longitude: newLocation.longitude)
            var title = ""
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placeMarks, error) in
                if error != nil{
                    print (error!)
                }
                else{
                    if let placeMark = placeMarks?[0]{
                        if placeMark.subThoroughfare != nil{
                            title += placeMark.subThoroughfare! + " "
                        }
                        if placeMark.thoroughfare != nil{
                            title += placeMark.thoroughfare!
                        }
                        
                    }
                }
                if title == ""{
                    
                    title = "Added \(NSDate())"
                    
                }
                let annotation = MKPointAnnotation()
                annotation.coordinate = newLocation
                annotation.title = title
                self.map.addAnnotation(annotation)
                places.append(["name":title,"lat":String(newLocation.latitude),"long":String(newLocation.longitude)])
                UserDefaults.standard.set(places, forKey: "places")

            })
            
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        self.map.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "My location"
        self.map.addAnnotation(annotation)
    }
}

