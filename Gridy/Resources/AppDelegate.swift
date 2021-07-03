//
//  AppDelegate.swift
//  Gridy
//
//  Created by Cynthia Nikolai on 12/8/20.
//  Copyright © 2020 Cynthia Nikolai. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // For non-scene-based versions of this app on iOS 13.1 and earlier.
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }

    // For non-scene-based versions of this app on iOS 13.1 and earlier.
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    @available(iOS 13.2, *)
    // For non-scene-based versions of this app on iOS 13.2 and later.
    func application(_ application: UIApplication, shouldSaveSecureApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    @available(iOS 13.2, *)
    // For non-scene-based versions of this app on iOS 13.2 and later.
    func application(_ application: UIApplication, shouldRestoreSecureApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
//    func application(_ application: UIApplication, viewControllerWithRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
//            return coder.decodeObject(forKey: "Restoration ID") as? UIViewController
//            
//        }
//        func application(_ application: UIApplication, didDecodeRestorableStateWith coder: NSCoder) {
//            UIApplication.shared.extendStateRestoration()
//            DispatchQueue.main.async {
//                UIApplication.shared.completeStateRestoration()
//            }
//        }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //self.window = UIWindow(frame: UIScreen.main.bounds)
//        let window = UIWindow(frame: UIScreen.main.bounds)
//        if UserDefaults.standard.valueExists(forKey:"piecesImages") {
//            print("here")
//            let bundle = Bundle.main
//            let storyboard = UIStoryboard(name: "Main", bundle: bundle)
//            var newViewController: UIViewController!
//            newViewController = storyboard.instantiateViewController(withIdentifier: "MainStoryboard")
//            // User has no defaults, open regular launch screen
//            let mainViewController = MainViewController()
//            window?.rootViewController = newViewController
//            window?.makeKeyAndVisible()
//            return true
//        }
//        else {
//            print("here2")
//            // User has defaults saved locally, open playfield screen of app
//            let playfieldViewController = PlayfieldViewController()
//            window?.rootViewController = playfieldViewController
//            window?.makeKeyAndVisible()
//        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

