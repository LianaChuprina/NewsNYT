//
//  SceneDelegate.swift
//  test
//
//  Created by Лиана Чуприна on 26.08.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            guard let _ = (scene as? UIWindowScene) else { return }
            if let windowScene = scene as? UIWindowScene {
                        let window = UIWindow(windowScene: windowScene)
                        let rootV = TabBarViewController()
                        let navVC = UINavigationController(rootViewController: rootV)
                        window.rootViewController = navVC
                        self.window = window
                        window.makeKeyAndVisible()
                    }
        }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

