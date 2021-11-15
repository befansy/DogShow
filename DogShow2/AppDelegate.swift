//
//  AppDelegate.swift
//  DogShow2
//
//  Created by Surgeont on 07.11.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = BreedsViewController()
        window?.makeKeyAndVisible()
        return true
    }

    

}

