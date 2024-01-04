//
//  MapView.swift
//  Vivid
//
//  Created by Roa Moha on 20/10/1444 AH.
//  Copyright © 1444 AH Vivid App. All rights reserved.
//

import SwiftUI
import MapKit
struct MapView: View {
    @StateObject var locationManager = MapViewModel.shared
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
            
            VStack {
                HStack {
                    
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Circle()
                            .frame(width: 50, height: 50)
                            .cornerRadius(25)
                            .foregroundColor(.black)
                            .opacity(0.1)
                            .overlay(Image("vividIcon")
                                .resizable()
                                .frame(width: 35, height: 35))
                    }
                    Spacer()
                }.padding(45)
                    Spacer()
                    
            }
        }
        
        .environment(\.layoutDirection, .leftToRight)
        .ignoresSafeArea()
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
