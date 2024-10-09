//
//  AppAppearence.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 3.10.2024.
//

import Foundation
import UIKit

class AppAppearance {
    static func setupAppearance() {
        // Tab Bar Appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .black // veya istediğiniz renk

        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }

        // Navigation Bar Appearance
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground() // Use transparent background for translucency
        navigationBarAppearance.backgroundColor = .clear // or any desired color
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        
        // Set UINavigationBar to be translucent
        UINavigationBar.appearance().isTranslucent = true // Make the navigation bar translucent
    }

}
