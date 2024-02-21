//
//  TabBarModel.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 27.01.2024.
//

import Foundation
import UIKit


struct TabBarModel {
    let iconName: String
    let title: String
    let viewController: UIViewController
    
    var icon: UIImage? {
        return UIImage(named: iconName)
    }
    
    static func createTabBarItems() -> [TabBarModel] {
        let firstTab = TabBarModel(iconName: "", title: "Home", viewController: HomeViewController())
        let secondTab = TabBarModel(iconName: "", title: "Search", viewController: SearchViewController())
        let thirdTab = TabBarModel(iconName: "", title: "Favorites", viewController: FavoriteViewController())
        
        
        return [firstTab, secondTab, thirdTab]
    }
}
