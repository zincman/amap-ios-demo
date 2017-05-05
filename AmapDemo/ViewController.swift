//
//  ViewController.swift
//  AmapDemo
//
//  Created by Derek on 04/05/2017.
//  Copyright © 2017 Derek. All rights reserved.
//

import UIKit

class ViewController: UIViewController, AMapSearchDelegate {
    @IBOutlet weak var latLabelOutlet: UILabel!
    @IBOutlet weak var lonLabelOutlet: UILabel!
    @IBOutlet weak var accuLabelOutlet: UILabel!
    @IBOutlet weak var regeoLabelOutlet: UILabel!
    
    let locationManager = AMapLocationManager()
//    let search = AMapSearchAPI()!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.locationTimeout = 10
        locationManager.reGeocodeTimeout = 10
        
        
        
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
                
//                let request = AMapReGeocodeSearchRequest()
//                request.location = AMapGeoPoint.location(withLatitude: CGFloat(location.coordinate.latitude), longitude: CGFloat(location.coordinate.longitude))
//                request.requireExtension = true
//                print("regeo request")
//                self!.search.aMapReGoecodeSearch(request)
            }
            if let reGeocode = reGeocode {
                NSLog("reGeocode:%@", reGeocode)
                self!.regeoLabelOutlet.text = reGeocode.formattedAddress
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
//        print("response")
//        if let reGeocode = response.regeocode {
//            NSLog("reGeocode:%@", reGeocode)
//            self.regeoLabelOutlet.text = reGeocode.formattedAddress
//        }
//    }
//    
//    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
//        print("Error: \(error)")
//    }
    
}

