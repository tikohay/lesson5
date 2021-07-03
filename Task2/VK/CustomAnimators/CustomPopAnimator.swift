//
//  CustomPopAnimator.swift
//  VK
//
//  Created by Karahanyan Levon on 14.02.2021.
//

import UIKit

class CustomPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let source = transitionContext.viewController(forKey: .from),
              let destination = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.sendSubviewToBack(destination.view)
        
        let translationForDestination = CGAffineTransform(translationX: source.view.frame.width, y: source.view.frame.height)
        let rotationForDestination = CGAffineTransform(rotationAngle: .pi / 2)
        let concatenatingForDestination = translationForDestination.concatenating(rotationForDestination)
        
        destination.view.transform = concatenatingForDestination
        
        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .calculationModeCubicPaced) {
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.75) {
                destination.view.transform = .identity
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                
                let translationForSource = CGAffineTransform(translationX: 0, y: source.view.frame.height)
                let rotationForSource = CGAffineTransform(rotationAngle: .pi * 1.5)
                let concatenatingForSource = translationForSource.concatenating(rotationForSource)
                
                source.view.transform = concatenatingForSource
            }
        } completion: { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.removeFromParent()
            } else if transitionContext.transitionWasCancelled {
                destination.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
}
