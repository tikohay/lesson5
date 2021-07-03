//
//  TestView.swift
//  VK
//
//  Created by Karahanyan Levon on 28.01.2021.
//

import UIKit

class TestView: UIView {

//    let gradientLayer = CAGradientLayer()
//
//    var testView: UIView {
//
//        let testView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        testView.layer.borderWidth = 2
//        testView.layer.borderColor = UIColor.white.cgColor
//        testView.layer.shadowRadius = 10
//        testView.layer.shadowOpacity = 1
//        testView.layer.shadowColor = UIColor.black.cgColor
//        return testView
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addSubview(testView)
//
//        testView.layer.addSublayer(gradientLayer)
//        gradientLayer.frame = testView.bounds
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        addSubview(testView)
//        layer.borderWidth = 2
//        layer.borderColor = UIColor.white.cgColor
//        layer.cornerRadius = frame.width / 2
//        layer.shadowColor = UIColor.red.cgColor
//        layer.shadowRadius = 5
//        layer.shadowOpacity = 1
//        layer.shadowOffset = CGSize(width: 0, height: 5)
//
//        gradientLayer.colors = [UIColor.black.cgColor, UIColor.white.cgColor]
//        gradientLayer.locations = [0 as NSNumber, 1 as NSNumber]
//        gradientLayer.startPoint = CGPoint.zero
//        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
//        testView.layer.addSublayer(gradientLayer)
//        gradientLayer.frame = testView.bounds
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        backgroundColor = .red
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        backgroundColor = .black
    }
}
