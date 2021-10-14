//
//  TabBarViewController.swift
//  test
//
//  Created by Alexandr on 16.09.2021.
//

import UIKit

class TabBarViewController: UIViewController,
                            UITabBarControllerDelegate {

    private var embedTabBarVC: UITabBarController = UITabBarController()

    override func viewDidLoad() {
        super.viewDidLoad()
        _SetupTabBar()
    }
}

extension TabBarViewController {

    func _SetupTabBar() {
        embedTabBarVC.viewControllers = [
            instantiateMostViewedVC(),
            instantiateMostEmailedVC(),
            instantiateMostSharedVC(),
            instantiateFavoriteVC()
        ]
        embedTabBarVC.tabBar.barTintColor = .white
        embedTabBarVC.tabBar.unselectedItemTintColor = .black
        embedTabBarVC.tabBar.tintColor = .brown
        self.navigationController?.isNavigationBarHidden = true
        addChildViewControllerToView(embedTabBarVC, toContainer: view)
    }
    func instantiateMostViewedVC() -> UINavigationController {
        let viewController: ViewedViewController = ViewedViewController()
        let presenter = PresenterViewed()
        viewController.presenter = presenter
        let navigationVc = UINavigationController(rootViewController: viewController)
        viewController.tabBarItem = UITabBarItem(
            title: "Viewed",
            image: UIImage(named: "popular"),
            selectedImage: UIImage(named: "popular")
        )
        return navigationVc
    }
    func instantiateMostEmailedVC() -> UINavigationController {
        let viewController: EmailViewController = EmailViewController()
        let presenterEmail = PresenterEmail()
        viewController.presenter = presenterEmail
        let navigationVc = UINavigationController(rootViewController: viewController)
        viewController.tabBarItem = UITabBarItem(
            title: "Email",
            image: UIImage(named: "email"),
            selectedImage: UIImage(named: "email")
        )
        return navigationVc
    }
    func instantiateMostSharedVC() -> UINavigationController {
        let viewController: HomeViewController = HomeViewController()
        let presenterHome = PresenterHome()
        viewController.presenter = presenterHome
        let navigationVc = UINavigationController(rootViewController: viewController)
        viewController.tabBarItem = UITabBarItem(
            title: "New",
            image: UIImage(named: "home"),
            selectedImage: UIImage(named: "home")
        )

        return navigationVc
    }
    func instantiateFavoriteVC() -> UINavigationController {
        let viewController: FavoritesViewController = FavoritesViewController()
        let presentorFavorites = PresenterFavorites()
        viewController.presenter = presentorFavorites
        let navigationVc = UINavigationController(rootViewController: viewController)
        viewController.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(named: "favorite"),
            selectedImage: UIImage(named: "favorite")
        )
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
