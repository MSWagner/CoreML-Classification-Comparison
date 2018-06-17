//
//  AppDelegate.swift
//  MLKit-Vision-Demo
//
//  Created by Matthias Wagner on 10.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var fireStoreController: FirestoreController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Appearance.setup()

        FirebaseApp.configure()
        fireStoreController = FirestoreController.shared

        return true
    }
}

