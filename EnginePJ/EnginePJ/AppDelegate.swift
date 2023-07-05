//
//  AppDelegate.swift
//  EnginePJ
//
//  Created by 王维一 on 2023/7/4.
//

import UIKit
import Flutter

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
     // 全局单例设计
    let engines = FlutterEngineGroup(name: "multiple-flutters", project: nil)
    let window  = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 尝试引擎预热
        let newEngine = self.engines.makeEngine(withEntrypoint: "main", libraryURI: "")
        newEngine.run()
        
        
        // Override point for customization after application launch.

        let vc = ViewController();
        let root = UINavigationController(rootViewController: vc)
        self.window.rootViewController = root
        
        // self.window.backgroundColor = UIColor.black
        self.window.makeKeyAndVisible()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }


}

