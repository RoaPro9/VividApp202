//
//  PathViewModel.swift
//  Vivid
//
//  Created by Roa Moha on 01/08/1444 AH.
//  
//

import Foundation
import CloudKit
import SwiftUI
import CoreLocation
import CoreLocationUI
class DrawingViewModel : ObservableObject {


    @ObservedObject private var vmCloud: CloudKitUserBootViewModel = CloudKitUserBootViewModel()
    @StateObject private var vmDarwing = DrawingViewModel()
    @StateObject var locationManager = MapViewModel.shared
//    let arDrawView = ARDrawView(frame: .zero, viewModel: ARDrawViewModel())
    
    init (){
        
    }



    func test(_ age: Int){

    }
//    func fetchList(_ currentClLocation:CLLocation , completion: @escaping (_ array: [(data: [Data], location: CLLocation)]) -> Void) {
//        let predicate = NSPredicate(value: true)
//        let query = CKQuery(recordType: "Drawing", predicate: predicate)
//
//        vmCloud.container.publicCloudDatabase.perform(query, inZoneWith: nil) { [weak self] (records, error) in
//            if let error = error {
//                print("Error fetching records: \(error)")
//            } else if let records = records {
//                var drawingArray: [(data: [Data], location: CLLocation)] = []
//
//                for record in records {
//                    guard let drawingBytes = record.object(forKey: "compressedDrawingBytes") as? Data else {
//                        continue
//                    }
//
//                    if let arrayOfData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(drawingBytes) as? [Data] {
//                        if let clocation = record["location"] as? CLLocation {
//                            
//                            
//                            // TODO
////                            if locationManager.currentLocation?.altitude == clocation.altitude {
//                                
////                            }
//                            print("SSSSS-1-\(currentClLocation.coordinate.latitude),\(currentClLocation.coordinate.longitude)")
//                            print("SSSSS-2-\(clocation.coordinate.latitude),\(clocation.coordinate.longitude)")
//                            drawingArray.append((data: arrayOfData, location: clocation))
//                            
//                        } else {
//                            drawingArray.append((data: arrayOfData, location: CLLocation(latitude: 0, longitude: 0)))
//                        }
//                    }
//                }
//
//                completion(drawingArray)
//            }
//        }
//    }

    func fetchList(_ currentClLocation: CLLocation, completion: @escaping (_ array: [(data: [Data], location: CLLocation)]) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Drawing", predicate: predicate)

        vmCloud.container.publicCloudDatabase.perform(query, inZoneWith: nil) { [weak self] (records, error) in
            if let error = error {
                print("Error fetching records: \(error)")
            } else if let records = records {
                var drawingArray: [(data: [Data], location: CLLocation)] = []

                for record in records {
                    guard let drawingBytes = record.object(forKey: "compressedDrawingBytes") as? Data else {
                        continue
                    }

                    if let arrayOfData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(drawingBytes) as? [Data] {
                        if let clocation = record["location"] as? CLLocation {
                            // Compare the coordinates with the user's current location
                            print("object latiutude:\(clocation.coordinate.latitude)")
                            print("object longlaitude:\(clocation.coordinate.longitude)")
                            let distance = currentClLocation.distance(from: clocation)
                            print ("distance : \(distance)")
                            print("DD:\(currentClLocation.coordinate)")
                            
//                            let distance = self?.haversineDistanceInMeters(from:  currentClLocation.coordinate, to: clocation.coordinate)
                            // clocation.coordinate
                            // currentClLocation
                            // Set a distance threshold (adjust this based on your requirements)
                            let copDistance: Double  = 10 * 3 // meters
                            print("d:\(distance)")
                            print("d1:\(copDistance)")
                            if distance <= copDistance {
                                drawingArray.append((data: arrayOfData, location: clocation))
                            }
                        }
                    }
                }

                completion(drawingArray)
            }
        }
    }
    
    func haversineDistanceInMeters(from coordinate1: CLLocationCoordinate2D, to coordinate2: CLLocationCoordinate2D) -> Double {
            let earthRadius = 6371.0 // Earth radius in kilometers
            
            let dLat = (coordinate2.latitude - coordinate1.latitude).toRadians()
            let dLon = (coordinate2.longitude - coordinate1.longitude).toRadians()
            
            let a = sin(dLat / 2) * sin(dLat / 2) + cos(coordinate1.latitude.toRadians()) * cos(coordinate2.latitude.toRadians()) * sin(dLon / 2) * sin(dLon / 2)
            let c = 2 * atan2(sqrt(a), sqrt(1 - a))
            
            let distance = earthRadius * c * 1000.0 // Distance in meters
            
            return distance
        }
    func savePath(_ drawingArray: [Data], completion: @escaping () -> Void) {
        if drawingArray.isEmpty {
            print("drawingArray is empty, nothing to save")
            return
        }
        
        guard let dataToUpload = try? NSKeyedArchiver.archivedData(withRootObject: drawingArray, requiringSecureCoding: true) as Data else {
            return
        }
        guard let location = locationManager.location else {
            print("Error current location empty")
            return
        }
        let pathRecord = CKRecord(recordType: "Drawing")//, recordID: .init(recordName: ""))
        
        pathRecord["compressedDrawingBytes"] = dataToUpload
        
        // Get the user's current location
      
        
        // let location = CLLocation(latitude: locationManager.region.center.latitude, longitude: locationManager.region.center.longitude)
        let latitude = locationManager.region.center.latitude
        let longitude = locationManager.region.center.longitude
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        let altitude = CLLocationDistance()
//        print("d:1:\(")
        
       
//        let arAnchor = ARAnchor
        pathRecord["location"] = CLLocation.init(latitude:location.latitude , longitude:location.longitude )

        vmCloud.container.publicCloudDatabase.save(pathRecord) { (record, error) in
            if let error = error {
                print("Error saving to CloudKit: \(error.localizedDescription)")
            } else {
                print("Saved to CloudKit!")
                completion()
            }
        }
    }

    


}

extension Double {
    func toRadians() -> Double {
        return self * .pi / 180.0
    }
}
