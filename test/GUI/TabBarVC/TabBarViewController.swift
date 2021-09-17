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
        embedTabBarVC.tabBar.barTintColor = .white
        embedTabBarVC.tabBar.unselectedItemTintColor = .black
        embedTabBarVC.tabBar.tintColor = .brown
        self.navigationController?.isNavigationBarHidden = true
       addChildViewControllerToView(embedTabBarVC, toContainer: view)
    }
    func instantiateMostViewedVC() -> UINavigationController {
        let vc: ViewedViewController = ViewedViewController()
        let navigationVc = UINavigationController(rootViewController: vc)
        vc.tabBarItem = UITabBarItem(
            title: "Viewed", image: UIImage(named: "2222"), selectedImage: UIImage(named: "2222"))
        return navigationVc
    }
    func instantiateMostEmailedVC() -> UINavigationController {
        let vc: EmailViewController = EmailViewController()
        let navigationVc = UINavigationController(rootViewController: vc)
        vc.tabBarItem = UITabBarItem(
            title: "Email", image: UIImage(named: "1111"), selectedImage: UIImage(named: "1111"))
        return navigationVc
    }
    func instantiateMostSharedVC() -> UINavigationController {
        let vc: HomeViewController = HomeViewController()
        let navigationVc = UINavigationController(rootViewController: vc)
        vc.tabBarItem = UITabBarItem(
            title: "New", image: UIImage(named: "333"), selectedImage: UIImage(named: "333"))
        
        return navigationVc
    }
    func instantiateFavoriteVC() -> UINavigationController {
        let vc: FavoritesViewController = FavoritesViewController()
        let navigationVc = UINavigationController(rootViewController: vc)
        vc.tabBarItem = UITabBarItem(
            title: "Favorites", image: UIImage(named: "4444"), selectedImage: UIImage(named: "4444"))
        return navigationVc
    }
}

extension UIViewController {

    func addChildViewControllerToView(_ child: UIViewController, toContainer container: UIView) {

        addChild(child)

        child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        child.view.frame = container.bounds
        container.addSubview(child.view)

        child.didMove(toParent: self)
    }
}
