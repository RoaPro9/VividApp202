////
////  ContentView.swift
////  Places
////
////  Created by Hajar Nashi on 20/02/2023.
////
//
//import SwiftUI
//import MapKit
//
//struct mapView: View {
//    
//    @EnvironmentObject var localSearchService: LocalSearchService
//    @State private var search: String = ""
//    
//    var body: some View {
//        VStack {
//            
//            //Search Bar//
//            
////            TextField("Search", text: $search)
////                .textFieldStyle(.roundedBorder)
////                .onSubmit {
////                    localSearchService.search(query: search)
////                }.padding()
//            
////            if localSearchService.landmarks.isEmpty {
////                Text("Delicious places awaits you!")
////                    .padding()
////                    .overlay(
////                            RoundedRectangle(cornerRadius: 16)
////                                .stroke(.gray, lineWidth: 2)
////                        )
////            } else {
////                LandmarkListView()
////            }
//            
//            Map(coordinateRegion: $localSearchService.region, showsUserLocation: true, annotationItems: localSearchService.landmarks) { landmark in
//                
//                MapAnnotation(coordinate: landmark.coordinate) {
//                    Image(systemName: "heart.fill")
//                        .foregroundColor(localSearchService.landmark == landmark ? .purple: .red)
//                        .scaleEffect(localSearchService.landmark == landmark ? 2: 1)
//                }
//                
//            }
//            
//            Spacer()
//        }.ignoresSafeArea()
//    }
//}
////
////struct mapView: PreviewProvider {
////    static var previews: some View {
////        mapView().environmentObject(LocalSearchService())
////    }
////}
