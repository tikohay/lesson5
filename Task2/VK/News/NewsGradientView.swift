//
//  NewsGradientView.swift
//  VK
//
//  Created by Karahanyan Levon on 03.02.2021.
//

import UIKit

class NewsGradientView: UIView {

    @IBInspectable var startColor: UIColor = .white {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable var endColor: UIColor = .white {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable var startLocation: CGFloat = 1 {
        didSet {
            updateLocation()
        }
    }
    
    @IBInspectable var endLocation: CGFloat = 1 {
        didSet {
            updateLocation()
        }
    }
    @IBInspectable var startPoint: CGPoint = .zero {
        didSet {
            updateStartPoint()
        }
    }
    
    @IBInspectable var endPoint: CGPoint = CGPoint(x: 0, y: 1) {
        didSet {
            updateEndPoint()
        }
    }
    
    override static var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    var gradientLayer: CAGradientLayer {
        return self.layer as! CAGradientLayer
    }
    
    func updateLocation() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    
    func updateStartPoint() {
        gradientLayer.startPoint = startPoint
    }
    
    func updateEndPoint() {
        gradientLayer.endPoint = endPoint
    }
}
