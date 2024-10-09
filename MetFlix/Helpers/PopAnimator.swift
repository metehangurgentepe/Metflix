//
//  PopAnimator.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 8.10.2024.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 0.3
    var presenting = true
    var originFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        
        containerView.addSubview(toView)
        toView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(
          withDuration: duration,
          animations: {
            toView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
          },
          completion: { _ in
            transitionContext.completeTransition(true)
          }
        )
    }
    

}
