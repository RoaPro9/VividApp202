

import SwiftUI
import ARKit

struct ARDrawViewContainer: UIViewRepresentable {
    @State var hexColor: String = "#FFFFFF"
    @ObservedObject var viewModel: ARDrawViewModel

    func makeUIView(context: Context) -> ARDrawView {
        let arDrawView = ARDrawView(frame: .zero, viewModel: viewModel)
        arDrawView.hexColor = hexColor
        arDrawView.lineWidth = 20.0
        
//        arDrawView.drawerDelegate = context.coordinator
        return arDrawView
    }
    
    func updateUIView(_ uiView: ARDrawView, context: Context) {
        uiView.hexColor = hexColor
        uiView.lineWidth = 20.0
        uiView.viewModel = viewModel
    }
}
