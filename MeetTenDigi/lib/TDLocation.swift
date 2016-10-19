//
//  TDLocation.swift
//  MeetTenDigi
//
//  Created by derek lee bronston on 10/18/16.
//  Copyright © 2016 Bytedissident. All rights reserved.
//

import UIKit
import CoreLocation

class TDLocation: NSObject,CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    var latitude = 0.0
    var longitude = 0.0
    dynamic var locationUpdated = 0.0
    dynamic var locationUpdateFailed = 0.0
    
    func startGPS(){
       print("START")
        self.locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestLocation()
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        }else{
            auth()
        }
    }
    
    func stopGPS(){
        self.locationManager.stopUpdatingLocation()
    }
    
    func auth(){
        
        self.locationManager.requestLocation()
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
       
        case .authorized:
            self.startGPS()
            break
           
        case .authorizedWhenInUse:
            self.startGPS()
            break
            
        case .denied:
            self.locationUpdateFailed = NSDate.timeIntervalSinceReferenceDate
            break
            
        case .notDetermined:
            self.locationUpdateFailed = NSDate.timeIntervalSinceReferenceDate
            break
            
        case .restricted:
            self.locationUpdateFailed = NSDate.timeIntervalSinceReferenceDate
            break
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let l = locations.last {
            //turn off GPS tto save battery
            self.stopGPS()
            
            self.latitude = l.coordinate.latitude
            self.longitude = l.coordinate.longitude
            self.locationUpdated = NSDate.timeIntervalSinceReferenceDate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("error")
        self.locationUpdateFailed = NSDate.timeIntervalSinceReferenceDate
    }
}
