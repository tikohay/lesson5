//
//  CustomPushAnimator.swift
//  VK
//
//  Created by Karahanyan Levon on 14.02.2021.
//

import UIKit

class CustomPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let source = transitionContext.viewController(forKey: .from),
              let destination = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        transitionContext.containerView.addSubview(destination.view)
        destination.view.frame = source.view.frame
        
        let rotationForDestination = CGAffineTransform(rotationAngle: .pi * 1.5)
        let translationForDestination = CGAffineTransform(translationX: destination.view.frame.height, y: source.view.frame.width)
        let concatenatingTransformForDestination = rotationForDestination.concatenating(translationForDestination)
        destination.view.transform = concatenatingTransformForDestination
                
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: .calculationModePaced) {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                destination.view.transform = .identity
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                let rotationForSource = CGAffineTransform(rotationAngle: .pi / 2)
                let translationForSource = CGAffineTransform(translationX: -source.view.frame.width, y: source.view.frame.height)
                let concatenatingTransformForSource = translationForSource.concatenating(rotationForSource)
              
                source.view.transform = concatenatingTransformForSource
            }
        } completion: { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
}
