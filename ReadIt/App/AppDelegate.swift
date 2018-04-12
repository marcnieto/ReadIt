//
//  AppDelegate.swift
//  ReadIt
//
//  Created by Marc Nieto on 4/10/18.
//  Copyright © 2018 Marc Nieto. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Initialization

    static var shared: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }

    var window: UIWindow?

    var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }

    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
}

