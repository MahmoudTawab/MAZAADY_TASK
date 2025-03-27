//
//  AppDelegate.swift
//  MAZAADY_TASK
//
//  Created by Mohamed Tawab on 26/03/2025.
//


import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Initialize the main application window with the screen's bounds
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Set the root view controller to CustomTabBarController
        window?.rootViewController = CustomTabBarController()
        
        // Make the window key and visible
        window?.makeKeyAndVisible()
        
        return true
    }
}

