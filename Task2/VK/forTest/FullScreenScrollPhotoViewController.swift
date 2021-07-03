//
//  FullScreenScrollPhotoViewController.swift
//  VK
//
//  Created by Karahanyan Levon on 11.02.2021.
//

import UIKit

class FullScreenScrollPhotoViewController: UIViewController {
    
//    var user: UserClass?
    var images: [String]?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        images = user?.imagesName
        
        setupScrollView()
    }
    
    private func setupScrollView() {
        
        scrollView.contentSize.width = self.scrollView.frame.width * CGFloat(images!.count)
        scrollView.backgroundColor = .white
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        guard let images = images else { return }
        
        for (i, image) in images.enumerated() {
            let view = AnimationView()
            
            view.frame = CGRect(x: self.scrollView.frame.width * CGFloat(i),
                                y: 0,
                                width: self.view.frame.width,
                                height: self.scrollView.frame.height)
            
            view.imageView.image = UIImage(named: image)
            view.tag = i + 10
            self.scrollView.addSubview(view)
        }
    }
}

extension FullScreenScrollPhotoViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let tempo = 200 / scrollView.frame.width
        
        guard let images = images else { return }
        
        for i in 0 ..< images.count {
            let parallaxView = scrollView.viewWithTag(i + 10) as! AnimationView
            let newX: CGFloat = tempo * (scrollView.contentOffset.x - CGFloat(i) * scrollView.frame.width)
            parallaxView.imageView.frame = CGRect(x: newX,
                                                  y: parallaxView.imageView.frame.origin.y,
                                                  width: parallaxView.imageView.frame.width,
                                                  height: parallaxView.imageView.frame.height)
        }
    }
}
    

