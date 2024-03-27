//
//  AppDelegate.swift
//  FinalProject
//
//  Created by Bien Le Q. on 8/26/19.
//  Copyright © 2019 Asiantech. All rights reserved.
//

import UIKit
import SVProgressHUD

typealias HUD = SVProgressHUD
let screenHeight = UIScreen.main.bounds.height
let screenWidth = UIScreen.main.bounds.width

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private func createTabbar() {
        // HomeVC
        let vc = HomeViewController()
        let homeViewModel = HomeViewModel()
        vc.viewModel = homeViewModel
        let homeNavi = UINavigationController(rootViewController: vc)
        vc.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        // FavoritesVC
        let favoritesVC = FavoritesViewController()
        let favoritesNavi = UINavigationController(rootViewController: favoritesVC)
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "bookmark"), selectedImage: UIImage(systemName: "bookmark.fill"))
        // UserVC
        let addRecipeVC = AddRecipeViewController()
        let addRecipeNavi = UINavigationController(rootViewController: addRecipeVC)
        addRecipeVC.tabBarItem = UITabBarItem(title: "Add Recipe", image: UIImage(systemName: "plus.circle"), selectedImage: UIImage(systemName: "plus.circle.fill"))
        // Tabbar Controller
        let tabbarController = UITabBarController()
        tabbarController.viewControllers = [homeNavi, favoritesNavi, addRecipeNavi]
        tabbarController.tabBar.tintColor = .black
        window?.rootViewController = tabbarController
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        createTabbar()
        return true
    }
}
