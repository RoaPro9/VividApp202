////
////  LocationManager.swift
////  Vivid
////
////  Created by Roa Moha on 19/10/1444 AH.
////  Copyright © 1444 AH Vivid App. All rights reserved.
////
//
//import Foundation
//import CoreLocation
//import CoreLocationUI
//import MapKit
//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    var manager : CLLocationManager?
//
//    @Published var location: CLLocationCoordinate2D?
//@Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
//
//
//    override init() {
//        super.init()
//
//    }
//    func checkIfLocationServicesEnabled(){
//        if CLLocationManager.locationServicesEnabled(){
//            manager = CLLocationManager()
//            manager!.delegate = self
//            checkLocationAuthorization()
//
//        }
//    }
//
//   private func checkLocationAuthorization (){
//        guard let manager = manager else {return}
//        switch manager.authorizationStatus{
//
//        case .notDetermined:
//            manager.requestWhenInUseAuthorization()
//        case .restricted:
//print("your location is restricted likely due to parenta controls. ")
//        case .denied:
//            print("you have denied Vivid location permission. Go into settings to change it.")
//        case .authorizedAlways, .authorizedWhenInUse:
//            if let loc = manager.location{
//                print(MKCoordinateRegion(center: loc.coordinate, span: MKCoordinateSpan()), "😀")
//
////                print(MKCoordinateRegion(center: loc.coordinate , span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), "😀")
//            }
//
//      break
//        @unknown default:
//            break
//        }
//
//    }
//    //-------------------//
//    func requestLocation() {
//        manager?.requestLocation()
//    }
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        checkLocationAuthorization()
//    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//            guard let coordinate = locations.last?.coordinate else { return }
//            print(String(coordinate.latitude))
//        }
//
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Location manager failed with error: \(error.localizedDescription)")
//    }
//
//}import Foundation
import Foundation
import SwiftUI
import MapKit

final class MapViewModel_1 :NSObject,CLLocationManagerDelegate, ObservableObject{
    
    func startupChecks(){
        print("checking location services")
        deviceLocationManager.delegate = self
        
        self.deviceLocationManager = CLLocationManager()
        switch deviceLocationManager.accuracyAuthorization {
            
        case .fullAccuracy:
            print("")
            // TODO: handle fullAccuracy
        case .reducedAccuracy:
            // TODO: handle reducedAccuracy - request temporary full accuracy
            print("")
        @unknown default:
            // handle default
            print("")
            
        }
    }
    @Published var currentLocation: CLLocation?
    
    
    @Published  var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 24.86405, longitude: 46.71735), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    
    func getUserLoocation() {
        deviceLocationManager.requestLocation()
    }
    
    var deviceLocationManager = CLLocationManager()
    
    
    private func checkLocationAuthorization(){
        
        //        guard let deviceLocationManager = deviceLocationManager else {return }
        
        switch deviceLocationManager.authorizationStatus{
        case .notDetermined:
            deviceLocationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
            
        case .denied:
            
            break
        case .authorizedAlways, .authorizedWhenInUse:
            if let location = deviceLocationManager.location{
                self.region = MKCoordinateRegion(
                    center:location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )
            }
            
            break
        @unknown default:
            break
        }
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last
        //        locations.last.map {
        //            self.region = MKCoordinateRegion(
        //                center: CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude),
        //                span: MKCoordinateSpan(latitudeDelta:0.1, longitudeDelta: 0.1)
        //            )
        //        }
        //        locations.last.map {
        //                   self.region = MKCoordinateRegion(
        //                       center: CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude),
        //                       span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        //                   )
        //                   self.currentLocation = $0
        //               }
    }
    
    
}
import CoreLocation
import CoreLocationUI

final class MapViewModel :NSObject,CLLocationManagerDelegate, ObservableObject{
    static let shared = MapViewModel()
    let manager = CLLocationManager()
    @Published var currentLocation = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?
    @Published  var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 24.86405, longitude: 46.71735), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    
   private override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestLocation() {
        manager.requestWhenInUseAuthorization()

        manager.startUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error:\(error.localizedDescription)")
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
    }
}
