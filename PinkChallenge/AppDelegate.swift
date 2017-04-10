//
//  AppDelegate.swift
//  PinkChallenge
//
//  Created by Bruno Silva on 05/04/2017.
//  Copyright © 2017 Bruno Silva. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
     
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        let navigationVC = UINavigationController(rootViewController: ViewController())
        window?.rootViewController = navigationVC
        
        return true
    }


}

