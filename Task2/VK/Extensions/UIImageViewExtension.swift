//
//  UIImageViewExtension.swift
//  VK
//
//  Created by Karahanyan Levon on 09.03.2021.
//

import UIKit

extension UIImageView {
    
    static func getPhoto(from url: String, imageView: UIImageView){
        guard let url = URL(string: url),
              let data = try? Data(contentsOf: url) else { return }
        imageView.image = UIImage(data: data)
    }
}
