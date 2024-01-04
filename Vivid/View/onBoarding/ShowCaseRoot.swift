//
//  ShowCaseRoot.swift
//  Vivid
//
//  Created by SAF on 26/11/1444 AH.
//  Copyright © 1444 AH Vivid App. All rights reserved.
//
import SwiftUI

extension View {
    @ViewBuilder
    func showCase(order: Int, title: String, des: String, cornerRadius: CGFloat, style: RoundedCornerStyle = .continuous, scale: CGFloat = 1) -> some View {
        self.anchorPreference(key: HighlightAnchorkey.self, value: .bounds) { anchor in
            let highlight = Highlight(anchor: anchor, title: title, des: des, cornerRadius: cornerRadius, style: style, scale: scale)
            return [order: highlight]
        }
    }
}

struct ShowCaseRoot: ViewModifier {
    var showHighlights: Bool
    var onFinished: () -> ()
    @State private var highlightOrder: [Int] = []
    @State private var currentHighlight: Int = 0
    @State private var showView: Bool = true
    @State private var showTitle: Bool = false
    @State private var showDescription: Bool = false
    @Namespace private var animation
    
    func body(content: Content) -> some View {
        content
            .onPreferenceChange(HighlightAnchorkey.self) { value in
                highlightOrder = Array(value.keys).sorted()
            }
            .overlayPreferenceValue(HighlightAnchorkey.self) { preferences in
                if highlightOrder.indices.contains(currentHighlight), showHighlights, showView {
                    if let highlight = preferences[highlightOrder[currentHighlight]] {
                        HighlightView(highlight)
                    }
                }
            }
    }
    
    @ViewBuilder
    func HighlightView(_ highlight: Highlight) -> some View {
        GeometryReader { proxy in
            let highlightRect = proxy[highlight.anchor]
            let safeArea = proxy.safeAreaInsets
            
            Rectangle()
                .fill(Color.black.opacity(0.5))
                .reverseMask {
                    Rectangle()  // Rectangle above the buttons
                        .matchedGeometryEffect(id: "HIGHLIGHTSHAPE", in: animation)
                        .frame(width: highlightRect.width + 5, height: highlightRect.height + 5)
                        .clipShape(RoundedRectangle(cornerRadius: highlight.cornerRadius, style: highlight.style))
                        .scaleEffect(highlight.scale)
                        .offset(x: highlightRect.minX - 2.5, y: highlightRect.minY + safeArea.top - 2.5)
                }
                .ignoresSafeArea()
                .onTapGesture {
                    if currentHighlight >= highlightOrder.count - 1 {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showView = false
                        }
                        onFinished()
                    } else {
                        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.7)) {
                            showTitle = false
                            showDescription = false
                            currentHighlight += 1
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            showTitle = true
                            showDescription = true
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        showTitle = true
                        showDescription = true
                    }
                }
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: highlightRect.width + 20, height: highlightRect.height + 20 )
                .clipShape(RoundedRectangle(cornerRadius: highlight.cornerRadius, style: highlight.style))
                .popover(isPresented: $showDescription) {
                    //VStack {
                        Text(highlight.title)
                            .foregroundColor(Color("PrimarycolorBlue"))
                            .padding(.horizontal, 10)
                            .presentationCompactAdaptation(.popover)
                            .interactiveDismissDisabled()
                        Text(highlight.des)
                            .padding(.horizontal, 10)
                            .presentationCompactAdaptation(.popover)
                            .multilineTextAlignment(.center)
                            .interactiveDismissDisabled()
                    //}
                    //.padding()
                }
                .scaleEffect(highlight.scale)
                .offset(x: highlightRect.minX - 5, y: highlightRect.minY - 5)
            
        }
        //.environment(\.layoutDirection, .rightToLeft)
    }
}

fileprivate struct HighlightAnchorkey: PreferenceKey {
    static var defaultValue: [Int: Highlight] = [:]
    static func reduce(value: inout [Int: Highlight], nextValue: () -> [Int: Highlight]) {
        value.merge(nextValue()) { $1 }
    }
}

extension View {
    @ViewBuilder
    func reverseMask<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        self
            .mask {
                Rectangle()
                    .overlay(alignment: .topLeading) {
                        content()
                            .blendMode(.destinationOut)
                    }
            }
    }
}

//struct ShowCaseHelper_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
