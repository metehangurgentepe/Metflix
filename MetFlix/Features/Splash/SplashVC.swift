//
//  SplashVC.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 8.10.2024.
//

import UIKit
import Lottie

class SplashVC: UIViewController {
    
    let animationView = LottieAnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        setupAnimation()
    }
    
    private func setupAnimation() {
        if let animation = LottieAnimation.named("splash") {
            animationView.animation = animation
        }
        
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .playOnce
        animationView.play { [weak self] (finished) in
            if finished {
                self?.navigateToNextScreen()
            }
        }
        
        view.addSubview(animationView)
        
        animationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    private func navigateToNextScreen() {
        let nextVC = UINavigationController(rootViewController: SelectProfileVC())
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true, completion: nil)
    }
}
