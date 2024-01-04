//
//  MapIcon.swift
//  Vivid
//
//  Created by Jumanah  on 25/05/2023.
//  Copyright © 2023 Vivid App. All rights reserved.
//

import SwiftUI

struct MapIcon: View {
    @State var ispressed : Bool = false
    var body: some View {
        HStack {
            Button {
                ispressed = true
            } label: {
                Circle()
                    .frame(width: 50, height: 50)
                    .cornerRadius(25)
                    .foregroundColor(.black)
                    .opacity(0.1)
                    .overlay(Image(systemName: "globe.asia.australia")
                        .font(.system(size: 35))
                        .foregroundColor(.white)
                    )
            }.fullScreenCover(isPresented: $ispressed, content: MapView.init)
            .showCase(
                order: 3,
                title: "Beyond the map",
                des: "Look around you! explore the area",
                cornerRadius: 10,
                style:.continuous)
            .padding(.top,60)
            Spacer()
            
            
        } .padding(.top)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        
    }
}

struct MapIcon_Previews: PreviewProvider {
    static var previews: some View {
        MapIcon()
    }
}
