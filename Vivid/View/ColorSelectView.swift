

import SwiftUI
import Combine
struct ColorSelectView: View {
    
    
    @State private var isWhite = true
    @Binding var hexColor: String
    
    var body: some View {
        
        HStack{
            
            Button {
                
                isWhite.toggle()
                hexColor =  isWhite ? "#FFFFFF" : "#000000"
            } label: {
                Image(systemName: "pencil")
                    .foregroundColor(Color(hex: hexColor)) 
                
            }
            
        }
    }
}

struct ColorSelectView_Previews: PreviewProvider {
    static var previews: some View {
        ColorSelectView(hexColor: .constant("#ffffff"))
    }
}
