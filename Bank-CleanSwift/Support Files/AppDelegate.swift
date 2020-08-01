//
//  AppDelegate.swift
//  Bank-CleanSwift
//
//  Created by Scott Takahashi on 31/07/20.
//  Copyright © 2020 Scott Takahashi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let loginViewController = LoginViewController()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = loginViewController
        self.window?.makeKeyAndVisible()
        // Override point for customization after application launch.
        return true
    }


}

