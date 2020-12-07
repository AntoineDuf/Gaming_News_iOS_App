//
//  AppDelegate.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 02/07/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import UIKit
import FirebaseCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    override init() {
        FirebaseApp.configure()
    }
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        return true
    }
}
