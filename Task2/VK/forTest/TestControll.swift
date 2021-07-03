//
//  TestControll.swift
//  VK
//
//  Created by Karahanyan Levon on 28.01.2021.
//

import UIKit

class TestControll: UIControl {

    
    var button: UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.backgroundColor = .red
        
        return button
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        print("hy")
        return true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        button.frame = bounds
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(button)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubview(button)
        
    }
}
