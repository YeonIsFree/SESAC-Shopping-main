//
//  SceneDelegate.swift
//  SeSACShopping
//
//  Created by Seryun Chun on 2024/01/18.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        // MARK: - Onboarding Logic
        
        let onboardingState = UserDefaultManager.shared.getOnboardingStatus()
        
        if !onboardingState { // false: 온보딩 화면 진입
            guard let scene = (scene as? UIWindowScene) else { return }
            
            window = UIWindow(windowScene: scene)
            
            let sb = UIStoryboard(name: StoryBoardNames.Onboarding.rawValue, bundle: nil)
            guard let vc = sb.instantiateViewController(withIdentifier: OnboardingViewController.identifier) as? OnboardingViewController else { return }
            
            let nav = UINavigationController(rootViewController: vc)
            
            window?.rootViewController = nav
            
            window?.makeKeyAndVisible()
            
        } else { // true: 메인 화면 진입
            let sb = UIStoryboard(name: StoryBoardNames.Main.rawValue, bundle: nil)
            guard let vc = sb.instantiateViewController(withIdentifier: StoryBoardNames.MainTabBar.rawValue) as? UITabBarController else { return }
            
            let nav = UINavigationController(rootViewController: vc)
            
            window?.rootViewController = nav
            
            window?.makeKeyAndVisible()
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
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

