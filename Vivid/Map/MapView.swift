//
//  MapView.swift
//  Vivid
//
//  Created by Jumanah  on 24/05/2023.
//  Copyright © 2023 Vivid App. All rights reserved.
//

import SwiftUI
import MapKit

struct Place: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.808208, longitude: -122.415802), latitudinalMeters: 5000, longitudinalMeters: 5000)
    
    let annotations = [
        Place(name: "Burger Place", coordinate: CLLocationCoordinate2D(latitude: 37.807920, longitude: -122.422949)),
        Place(name: "Park", coordinate: CLLocationCoordinate2D(latitude: 37.804895, longitude: -122.429654)),
        Place(name: "Tacos", coordinate: CLLocationCoordinate2D(latitude: 37.807319, longitude: -122.421907))
    ]
    
    var body: some View {
        ZStack{
            
            Map(coordinateRegion: $region, annotationItems: annotations) { place in
                MapAnnotation(coordinate: place.coordinate){
                    HStack {
                        Circle()
                            .fill(
                                RadialGradient(gradient: Gradient(colors: [.red, .red, .orange, .yellow, .blue]), center: .center, startRadius: 1, endRadius: 50)
                            )
                            .frame(width: 100, height: 100)
                            .rotationEffect(Angle(degrees: 10))
                            .foregroundColor(.white)
                            .shadow(radius: 40)
                        
                    }.padding(10)
                    
                }
            }.ignoresSafeArea()
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
