//
//  TestView.swift
//  VK
//
//  Created by Karahanyan Levon on 23.01.2021.
//

import UIKit
 
class ViewForImage: UIView {
    
    @IBInspectable var shadowColor = UIColor.black
    @IBInspectable var shadowRadius = 4
    @IBInspectable var shadowOpacity = 0.4
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        changeViewForImage()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        changeViewForImage()
    }
    
    func changeViewForImage() {
        layer.cornerRadius = frame.width / 2
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = Float(shadowOpacity)
        layer.shadowRadius = CGFloat(shadowRadius)
        layer.shadowOffset = CGSize.zero
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.07, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseIn) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: .curveEaseOut) {
            self.transform = .identity
        }
    }
}
