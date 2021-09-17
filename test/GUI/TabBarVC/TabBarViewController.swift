//
//  TabBarViewController.swift
//  test
//
//  Created by Alexandr on 16.09.2021.
//

import UIKit

class TabBarViewController: UIViewController, UITabBarControllerDelegate  {

    private var embedTabBarVC: UITabBarController = UITabBarController()

    override func viewDidLoad() {
        super.viewDidLoad()
        SetupTabBar()
    }
}

extension TabBarViewController {

    func SetupTabBar() {
        embedTabBarVC.viewControllers = [instantiateMostViewedVC(), instantiateMostEmailedVC(), instantiateMostSharedVC(), instantiateFavoriteVC()]
        embedTabBarVC.tabBar.barTintColor = .systemYellow
        embedTabBarVC.tabBar.unselectedItemTintColor = .black
        embedTabBarVC.tabBar.tintColor = .white
        self.navigationController?.isNavigationBarHidden = true
       // addChildViewControllerToView(embedTabBarVC, toContainer: view)
    }
    func instantiateMostViewedVC() -> UINavigationController {
        let vc: ViewedViewController = ViewedViewController()
        let navigationVc = UINavigationController(rootViewController: vc)
        vc.tabBarItem = UITabBarItem(
            title: "Most Viewed News", image: UIImage(systemName: "mail.stack"), selectedImage: UIImage(systemName: "mail.stack"))
        return navigationVc
    }
    func instantiateMostEmailedVC() -> UINavigationController {
        let vc: EmailViewController = EmailViewController()
        let navigationVc = UINavigationController(rootViewController: vc)
        vc.tabBarItem = UITabBarItem(
            title: "Most Emailed News", image: UIImage(systemName: "paperplane"), selectedImage: UIImage(systemName: "paperplane"))
        return navigationVc
    }
    func instantiateMostSharedVC() -> UINavigationController {
        let vc: HomeViewController = HomeViewController()
        let navigationVc = UINavigationController(rootViewController: vc)
        vc.tabBarItem = UITabBarItem(
            title: "Most Shared News", image: UIImage(systemName: "globe"), selectedImage: UIImage(systemName: "globe"))
        return navigationVc
    }
    func instantiateFavoriteVC() -> UINavigationController {
        let vc: FavoritesViewController = FavoritesViewController()
        let navigationVc = UINavigationController(rootViewController: vc)
        vc.tabBarItem = UITabBarItem(
            title: "Favorite News", image: UIImage(systemName: "heart.fill"), selectedImage: UIImage(systemName: "heart.fill"))
        return navigationVc
    }
}
