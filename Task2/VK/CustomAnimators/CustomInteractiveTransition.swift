//
//  CustomInteractiveTransition.swift
//  VK
//
//  Created by Karahanyan Levon on 14.02.2021.
//

import UIKit

class CustomInteractiveTransition: UIPercentDrivenInteractiveTransition {

    var viewController: UIViewController? {
        didSet {
            let recognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleScreenEdgeGesture(_:)))
            recognizer.edges = .left
            viewController?.view.addGestureRecognizer(recognizer)
        }
    }
    
    var hasStarted = false
    var shouldFinish = false
    
    @objc func handleScreenEdgeGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        
        switch recognizer.state {
        case .began:
            hasStarted = true
            self.viewController?.navigationController?.popViewController(animated: true)
        case .changed:
            let translation = recognizer.translation(in: recognizer.view)
            let relativeTranslation = translation.x / (recognizer.view?.bounds.width ?? 1)
            let progress = max(0, min(1, relativeTranslation))
            
            shouldFinish = progress > 0.33
            
            update(progress)
        case .ended:
            hasStarted = false
            shouldFinish ? finish() : cancel()
        case .cancelled:
            hasStarted = false
            cancel()
        default:
            return
        }
    }
}
