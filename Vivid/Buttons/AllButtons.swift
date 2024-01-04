////
////  AllButtons.swift
////  Vivid
////
////  Created by Jumanah  on 25/05/2023.
////  Copyright © 2023 Vivid App. All rights reserved.
////
//
import SwiftUI

struct InfoOverlayView: View {
    
    let systemImageName: String
    let action: () -> Void
    
    var body: some View {
        
        VStack {
            Button {
                action()
            } label: {
                Text(Image(systemName: "\(systemImageName)")).foregroundColor(.white)
                    .font(.system(size: 24))
            }
        }
    }
}

struct InfoOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        InfoOverlayView(systemImageName: "", action: {} )
    }
}

