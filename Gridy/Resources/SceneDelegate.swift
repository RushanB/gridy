//
//  SceneDelegate.swift
//  Gridy
//
//  Created by Cynthia Nikolai on 12/8/20.
//  Copyright © 2020 Cynthia Nikolai. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

//    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
//        return scene.userActivity
//    }
//    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
//        //define variable strings
//        var storyBoard = ""
//                var newViewController = ""
//                if let storyBoardLoad = UserDefaults.standard.string(forKey: "storyBoard") {
//                    storyBoard = storyBoardLoad // restore and set variables
//                }
//                if let newViewControllerLoad = UserDefaults.standard.string(forKey: "newViewController") {
//                    newViewController = newViewControllerLoad
//                }
//               
//                if !(storyBoard == "") && !(newViewController == "") { // check that the string is not empty then set main view controller
//                    let storyboard : UIStoryboard = UIStoryboard(name: storyBoard, bundle: nil)
//                   
//                    let vc : UIViewController = storyboard.instantiateViewController(withIdentifier: newViewController)
//                    self.window?.rootViewController = vc
//                }
        
        
        //present(newViewController, animated: true, completion: nil)
        
//            if UserDefaults.standard.valueExists(forKey:"piecesImages") {
//                print("here")
//                let bundle = Bundle.main
//                let storyboard = UIStoryboard(name: "Main", bundle: bundle)
//                var newViewController: UIViewController!
//                newViewController = storyboard.instantiateViewController(withIdentifier: "MainStoryboard")
//                // User has no defaults, open regular launch screen
//                let mainViewController = MainViewController()
//                self.window?.rootViewController = newViewController
//                self.window?.makeKeyAndVisible()
//                return
//            }
//            else {
//                print("here2")
//                // User has defaults saved locally, open playfield screen of app
//                let playfieldViewController = PlayfieldViewController()
//                self.window?.rootViewController = playfieldViewController
//                self.window?.makeKeyAndVisible()
//            }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
//        let bundle = Bundle.main
//        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
//        var newViewController: UIViewController!
//        newViewController = storyboard.instantiateViewController(withIdentifier: "MainStoryboard")
//        // User has no defaults, open regular launch screen
//        //let mainViewController = MainViewController()
//        self.window?.rootViewController = newViewController
//        self.window?.makeKeyAndVisible()
//        return
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

