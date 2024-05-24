//
//  LocationController.swift
//  Group3
//
//  Created by Mohammad AbuHannood on 2023-07-08.
//

import Foundation

import Foundation
import CoreLocation
import Contacts
import MapKit

class LocationController : NSObject, ObservableObject, CLLocationManagerDelegate{
    private let locationManager = CLLocationManager()
    private var lastKnownLocation : CLLocation?
    private let geocoder = CLGeocoder()
    
    @Published var currentLocation : CLLocation?
    
    
    override init() {
        super.init()
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.delegate = self
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus{
        case .authorizedWhenInUse:
            //enable location features
            manager.startUpdatingLocation()
            break
        case .restricted, .denied:
            //disable location features or request permission
            //            manager.requestWhenInUseAuthorization()
            break
        case .notDetermined:
            //request permission
            manager.requestWhenInUseAuthorization()
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(#function, "location change is received")
        
        if locations.last != nil{
            //most recent location
            currentLocation = locations.last
        }else{
            //location.first - last know location
            //oldest or previously known location
            currentLocation = locations.first
        }
        
        lastKnownLocation = locations.first
        
        print(#function, "Last known location : \(String(describing: lastKnownLocation))")
        print(#function, "Most recent location : \(String(describing: currentLocation))")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, "Unable to receive location events : \(error.localizedDescription)")
    }
    
    func doForwardGeocoding(address: String, completion: @escaping (Result<(Double, Double), Error>) -> Void) {
        self.geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                completion(.failure(error))
            } else if let placemark = placemarks?.first,
                      let location = placemark.location {
                let obtainedLocation = (location.coordinate.latitude, location.coordinate.longitude)
                completion(.success(obtainedLocation))
            } else {
                completion(.failure(NSError(domain: "doForwardGeocoding", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to obtain placemark for forward geocoding"])))
            }
        }
    }
    
    //Escaping Closure
    func doReverseGeocoding(location : CLLocation, completionHandler: @escaping(String?, NSError?) -> Void){
        
        self.geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
            if (error != nil){
                print(#function, "Unable to perform reverse geocoding : \(String(describing: error?.localizedDescription))")
                
                //completionHandler of doReverseGeocoding()
                completionHandler(nil, error as NSError?)
            }else{
                if let placemarkList = placemarks, let placemark = placemarkList.first {
                    
                    print(#function, "Locality : \(placemark.locality ?? "NA")")
                    print(#function, "country : \(placemark.country ?? "NA")")
                    print(#function, "country code : \(placemark.isoCountryCode ?? "NA")")
                    print(#function, "sub-Locality : \(placemark.subLocality ?? "NA")")
                    print(#function, "Street-level address : \(placemark.thoroughfare ?? "NA")")
                    print(#function, "province : \(placemark.administrativeArea ?? "NA")")
                    
                    let postalAddress : String = CNPostalAddressFormatter.string(from: placemark.postalAddress!, style: .mailingAddress)
                    print(#function, "Postal Address : \(postalAddress)")
                    
                    completionHandler(postalAddress, nil)
                    
                }else{
                    print(#function, "Unable to obtain placemark for reverse geocoding")
                }
            }
        })
    }
    
    func addPinToMap(mapView: MKMapView, coordinates : CLLocationCoordinate2D){
        
        let mapAnnotation = MKPointAnnotation()
        mapAnnotation.coordinate = coordinates
        mapAnnotation.title = "Event location"
        mapView.addAnnotation(mapAnnotation)
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
}
