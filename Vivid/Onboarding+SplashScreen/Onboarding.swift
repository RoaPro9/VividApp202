//
//  Onboarding.swift
//  Vivid
//
//  Created by Jumanah  on 02/08/1444 AH.
//  Copyright © 1444 AH Vivid App. All rights reserved.
//

import SwiftUI

struct Onboarding: App {
    @AppStorage ("isOnboarding") var isOnboarding = true
    var body: some Scene {
        WindowGroup {
            if isOnboarding {
                OnboardingView()
            } else {
                SplashScreenView()
            }
        }
    }
}

//struct Onboarding_Previews: PreviewProvider {
//    static var previews: some View {
//        Onboarding()
//    }
//}
