//
//  TabBarViewController.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 25.01.2024.
//

import Foundation
import UIKit
import SnapKit


class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = TabBarModel.createTabBarItems().map{ $0.viewController }
        setupTabs()
        tabBar.isTranslucent = true
        tabBar.barStyle = .default
        tabBar.tintColor = .white
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = tabBar.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tabBar.insertSubview(blurEffectView, at: 0)
        
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func setupTabs() {
        let firstVC = TabBarModel.createTabBarItems()[0]
        let secondVC = TabBarModel.createTabBarItems()[1]
        let thirdVC = TabBarModel.createTabBarItems()[2]
        
        let home = self.createNav(
            with: firstVC.title,
            and: SFSymbols.home,
            selectedImage: SFSymbols.selectedHome,
            vc: firstVC.viewController)
        let search = self.createNav(
            with: secondVC.title,
            and: SFSymbols.newAndPopular,
            selectedImage: SFSymbols.selectedNewAndPopular,
            vc: secondVC.viewController)
        let saved = self.createNav(
            with: thirdVC.title,
            and: SFSymbols.favorites,
            selectedImage: SFSymbols.selectedFavorites,
            vc: thirdVC.viewController)
        
        self.setViewControllers([home,search,saved], animated: true)
    }
    
    private func createNav(with title: String, and image: UIImage?, selectedImage: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        nav.tabBarItem.selectedImage = selectedImage
        return nav
    }
}
