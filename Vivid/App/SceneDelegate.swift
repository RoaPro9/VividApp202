

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
   
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        // Create an instance of the LocationPermissionView
        let locationPermissionView = LocationPermissionView()

        // Set the LocationPermissionView as the root view of the scene
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: locationPermissionView)
        self.window = window
        window.makeKeyAndVisible()
    }


}
