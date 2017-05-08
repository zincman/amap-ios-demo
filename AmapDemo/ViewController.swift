//
//  ViewController.swift
//  AmapDemo
//
//  Created by Derek on 04/05/2017.
//  Copyright © 2017 Derek. All rights reserved.
//

import UIKit

class ViewController: UIViewController, AMapLocationManagerDelegate {
    @IBOutlet weak var latLabelOutlet: UILabel!
    @IBOutlet weak var lonLabelOutlet: UILabel!
    @IBOutlet weak var accuLabelOutlet: UILabel!
    @IBOutlet weak var regeoLabelOutlet: UILabel!
    
    let nativeLocationManager = CLLocationManager()
    let locationManager = AMapLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self     //  这一句好重要
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.locationTimeout = 15
        locationManager.reGeocodeTimeout = 15
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .restricted, .denied:
                print("No access at the first check.")
            case .notDetermined:
                print("Try to request the access")
                nativeLocationManager.requestAlwaysAuthorization()
            case .authorizedAlways, .authorizedWhenInUse:
                requestLocation()
            }
        } else {
            print("Location services are not enabled")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, didChange status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined, .restricted, .denied:
            print("No Access")
        case .authorizedWhenInUse, .authorizedAlways:
            print("Got access and start to locate")
            requestLocation()
        }
    }
    
    func requestLocation() {
        locationManager.requestLocation( withReGeocode: true, completionBlock: {
            [weak self] (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
            
            if let error = error {
                let error = error as NSError
                
                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
                    NSLog("定位错误:{\(error.code) - \(error.localizedDescription)};")
                    return
                }
                else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                    || error.code == AMapLocationErrorCode.timeOut.rawValue
                    || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                    || error.code == AMapLocationErrorCode.badURL.rawValue
                    || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                    || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {
                    
                    //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
                    NSLog("逆地理错误:{\(error.code) - \(error.localizedDescription)};")
                }
                else {
                    //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
                }
            }
            
            if let location = location {
                NSLog("location:%@", location)
                self!.latLabelOutlet.text = "lat:\(location.coordinate.latitude)"
                self!.lonLabelOutlet.text = "lon:\(location.coordinate.longitude)"
                self!.accuLabelOutlet.text = "accuracy:\(location.horizontalAccuracy)"
            }
            
            if let reGeocode = reGeocode {
                NSLog("reGeocode:%@", reGeocode)
                self!.regeoLabelOutlet.text = reGeocode.formattedAddress
            }
        })
    }
    
}

