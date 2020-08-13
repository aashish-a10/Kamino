//
//  AppDelegate.swift
//

import UIKit
import iOSKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private let container = AppDependencyContainer()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let frame = UIScreen.main.bounds
        let window = UIWindow(frame: frame)
        
        window.makeKeyAndVisible()
        window.rootViewController = container.makeRootViewController()
        self.window = window
        return true
    }
}
