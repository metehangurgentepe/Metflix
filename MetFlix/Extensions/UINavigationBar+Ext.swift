//
//  UINavigationBar+Exr.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 3.10.2024.
//

import UIKit

extension UINavigationBar {
    func applyBlurEffect() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true

        let blurEffect = UIBlurEffect(style: .light) // .dark veya .regular da kullanabilirsiniz
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.insertSubview(blurEffectView, at: 0)
    }
}
