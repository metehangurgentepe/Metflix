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
    
    var selectedProfileImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = TabBarModel.createTabBarItems().map{ $0.viewController }
        setupTabs()
        tabBar.isTranslucent = true
        tabBar.barStyle = .default
        tabBar.tintColor = .white
        
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
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
            with: "My Netflix",
            and: selectedProfileImage?.resized(to: .init(width: 20, height: 20)),
            selectedImage: selectedProfileImage?.resized(to: .init(width: 20, height: 20)),
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
    
    func animateProfileTabIcon() {
        guard let items = tabBar.items, let profileImage = selectedProfileImage?.resized(to: .init(width: 20, height: 20)) else { return }
        
        guard let tabBarItemFrame = tabBar.items?[2].value(forKey: "view") as? UIView else { return }
        
        let imageView = UIImageView(image: profileImage.withRenderingMode(.alwaysOriginal))
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: -100, y: view.frame.midY - 50, width: 50, height: 50)
        view.addSubview(imageView)
        
        let targetPosition = CGPoint(x: tabBarItemFrame.center.x - 50, y: tabBar.frame.origin.y - 50)
        
        UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseInOut], animations: {
        
            imageView.frame.origin = targetPosition
        }, completion: { _ in
        
            self.tabBar.items?[2].image = profileImage.withRenderingMode(.alwaysOriginal)
            
            imageView.removeFromSuperview()
        })
    }


}
