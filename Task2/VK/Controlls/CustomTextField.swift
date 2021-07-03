//
//  CustomTextField.swift
//  VK
//
//  Created by Karahanyan Levon on 14.02.2021.
//

import UIKit

class CustomTextField: UITextField {

    override func textRect(forBounds bounds: CGRect) -> CGRect {

        return bounds.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {

        return bounds.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 20))
    }

}
