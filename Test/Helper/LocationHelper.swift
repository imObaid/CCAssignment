//
//  LocationHelper.swift
//  Test
//
//  Created by Ubaid ur Rahman on 23/03/2019.
//  Copyright © 2019 Ubaid ur Rahman. All rights reserved.
//

import Foundation
import CoreLocation

public class LocationHelper : NSObject, CLLocationManagerDelegate{
    //private singleton object
    private static var _obj:LocationHelper? = nil
    //Singlton Propetry
    class var shared:LocationHelper{
        get{
            if(_obj == nil){
                _obj = LocationHelper()
                if _obj!.locationManager == nil{
                    _obj!.locationManager = CLLocationManager()
                }
            }
            
            let lockQueue = DispatchQueue(label: "obj")
            
            return lockQueue.sync {
                return _obj!
            }
        }
    }
    
    private var locationManager:CLLocationManager!
    private var _callback:((_ location:Location? , _ error:Error?)->Void)? = nil
    
    //prevent to create multiple ojects
    private override init() {
        print("Singleton -> LocationHelper Initialized")
    }
    
    func getCurrentLocation(withHandler callback:@escaping ((_ location:Location? , _ error:Error?)->Void)){
        self._callback = callback
        
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        _callback?(nil,error)
        
        locationManager.stopUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else{return}
        _callback?(Location.init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),nil)
        
        locationManager.stopUpdatingLocation()
    }
}

struct Location{
    var latitude:Double
    var longitude:Double
}
