//
//  SceneDelegate.swift
//  ButterFlySystem
//
//  Created by Oladipupo Oluwatobi on 09/06/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        /// 2. Create a new UIWindow using the windowScene constructor which takes in a window scene.
            let window = UIWindow(windowScene: windowScene)
        
        
        // Set up the first View Controller
        let navigation = UINavigationController(rootViewController: SearchMovieListViewController())
        navigation.tabBarItem.title = "Search"
        navigation.tabBarItem.image = UIImage(systemName: "house")
        navigation.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        
        // Set up the second View Controller
        let navigation1 = UINavigationController(rootViewController: FavoriteMoviesViewController())
        navigation1.tabBarItem.title = "Favorite"
        navigation1.tabBarItem.image = UIImage(systemName: "heart")
        navigation1.tabBarItem.selectedImage = UIImage(systemName: "heart.fill")
        
        // Set up the Tab Bar Controller to have two tabs
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([navigation, navigation1], animated: false)
        /// 3. Create a view hierarchy programmatically
        ///
           if #available(iOS 15.0, *) {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white //or whatever your color is
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

         /// 4. Set the root view controller of the window with your view controller
         window.rootViewController = tabBarController
         
         /// 5. Set the window and call makeKeyAndVisible()
         self.window = window
         window.makeKeyAndVisible()
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

