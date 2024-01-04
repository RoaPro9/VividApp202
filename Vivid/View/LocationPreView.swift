//
//  LocationPreView.swift
//  Vivid
//
//  Created by Roa Moha on 16/11/1444 AH.
//  Copyright © 1444 AH Vivid App. All rights reserved.
//

import Foundation
import SwiftUI
import CoreLocation

struct LocationPermissionView: View {
    @StateObject private var mapViewModel = MapViewModel()
    @State private var showSplashScreen = true
    @State private var shouldShowHighlight = false
    //
    @State var hexColor: String = "#FFFFFF"
    @StateObject private var vm = userViewModel()
    @StateObject var vmPath = DrawingViewModel()
    @StateObject private var viewModel = ARDrawViewModel()
    @State var currentIndex: Int = 0
    @StateObject var locationManager = MapViewModel()
    @State var showDrawing = false
    @State var updateView = false
    @State var shouldClear = false
    @State var drawingArray = [Data]()
    @State var drawings: [Data]? = [Data]()
//
        @State private var size = 0.8
        @State private var opacity = 0.5
//
    //
    init() {
        _shouldShowHighlight = State(initialValue: !UserDefaults.standard.bool(forKey: "hasShownHighlight"))
    }
    
    var body: some View {
        ZStack {
            if showSplashScreen {
                splashScreenView
            } else {
                contentView
            }
        }
    }
    private var splashScreenView : some View {
        ZStack {
            Color("Nouf")
                .ignoresSafeArea()
            VStack {
                Image("Splash")
                    .resizable()
                    .frame(width: 200, height: 250)
            }
            .scaleEffect(size)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn(duration: 1.2)) {
                    self.size = 0.9
                    self.opacity = 1.0
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showSplashScreen = false
                }
            }
        }
    }
    private var onboarding: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ZStack {
                    VStack {
                        Rectangle()
                            .frame(width: 40, height: 215)
                            .cornerRadius(25)
                            .foregroundColor(.black)
                            .opacity(0.1)
                            .overlay(
                                VStack(spacing: 20) {
                                    InfoOverlayView(systemImageName: "pencil.and.outline", action: {})
                                        .showCase(
                                            order: 0,
                                            title: "Start creating",
                                            des: "The pen tool allows you to start your\n masterpiece",
                                            cornerRadius: 10,
                                            style: .continuous
                                        )
                                    InfoOverlayView(systemImageName: "eraser", action:{
                                        self.viewModel.eraseDrawing.toggle()
                                    })
                                    
                                    
                                    InfoOverlayView(systemImageName: showDrawing ? "eye.slash" : "eye", action: {
                                        
                                        self.showDrawing.toggle()
                                        let completion: (_ array: [(data: [Data], location: CLLocation)]) -> Void = { drawingArray in
                                            //                                                print("Fetched drawing array: \(drawingArray)")
                                            
                                            //TODO
                                            
                                            
                                            
                                            self.viewModel.nodeToDraw = drawingArray
                                            
                                            //                                                vmPath.arDrawView.drawFromArray(drawingArray)
                                            print("DEBUG: returned")
                                        }
                                        // MARK: -  Fetch from DB
                                        vmPath.fetchList(locationManager.manager.location!, completion: completion)
                                    }).showCase(
                                        order: 1,
                                        title: "Have a quick peek",
                                        des: "Look around you! explore other people’s\n creations",
                                        cornerRadius: 10,
                                        style: .continuous
                                    )
                                    
                                    InfoOverlayView(systemImageName: "paperplane", action: {
                                        vmPath.savePath(self.viewModel.drawingArray) {
                                            DispatchQueue.main.async {
                                                self.viewModel.eraseDrawing.toggle()
                                            }
                                        }
                                    }).showCase(
                                        order: 2,
                                        title: "Send and Share",
                                        des: "It allows you to share your creations with\n others",
                                        cornerRadius: 10,
                                        style: .continuous
                                    )
                                }
                            )
                        Spacer()
                    }
                }
            }
        }
    }
    private var contentView: some View {
        ZStack {
            ARDrawViewContainer(viewModel: viewModel)
            VStack {
                HStack {
                    MapIcon()
                    Spacer()
                }
                Spacer()
            }
            .padding(.top, -5)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            onboarding
            .padding(.trailing, 10)
            .padding(.top, 70)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .onAppear {
                mapViewModel.requestLocation()
                if !UserDefaults.standard.bool(forKey: "hasShownHighlight") {
                    shouldShowHighlight = true
                    UserDefaults.standard.set(true, forKey: "hasShownHighlight")
                }
            }
            .modifier(ShowCaseRoot(showHighlights: shouldShowHighlight, onFinished: {
                print("Finished Onboarding")
            }))
        }
        .environment(\.layoutDirection, .leftToRight)
        .edgesIgnoringSafeArea(.all)
    }
}
