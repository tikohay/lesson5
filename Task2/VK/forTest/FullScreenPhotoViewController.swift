//
//  FullScreenPhotoViewController.swift
//  VK
//
//  Created by Karahanyan Levon on 14.01.2021.
//

import UIKit

class FullScreenPhotoViewController: UIViewController {

    var imageName: String?
    
    @IBOutlet weak var fullScreenScrollView: UIScrollView!
    @IBOutlet weak var fullScreenPhoto: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let imageName = imageName else { return }
        self.fullScreenPhoto?.image = UIImage(named: imageName)
        
        fullScreenScrollView.delegate = self
        zoomImage()
    }
   
    @IBAction func shareAction(_ sender: Any) {
        
        let shareController = UIActivityViewController(activityItems: [UIImage(named: imageName!)!], applicationActivities: nil)
        
        shareController.completionWithItemsHandler = {_, bool, _, _ in
            if bool {
                print("sending was successful")
            }
        }
        
        present(shareController, animated: true, completion: nil)
    }
}

extension FullScreenPhotoViewController: UIScrollViewDelegate {
    
    func zoomImage() {
        self.fullScreenScrollView.minimumZoomScale = 1.0
        self.fullScreenScrollView.maximumZoomScale = 6.0
        self.fullScreenScrollView.isUserInteractionEnabled = true
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return fullScreenPhoto
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if fullScreenScrollView.zoomScale > 1 {
            if let image = fullScreenPhoto?.image {
                let ratioW = (fullScreenPhoto?.frame.width)! / image.size.width
                let ratioH = (fullScreenPhoto?.frame.height)! / image.size.height
                
                let ratio = ratioW < ratioH ? ratioW : ratioH
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                
                let conditionLeft = newWidth * fullScreenScrollView.zoomScale > (fullScreenPhoto?.frame.width)!
                
                let left = 0.5 * (conditionLeft ? newWidth - (fullScreenPhoto?.frame.width)! : (fullScreenScrollView.frame.width - fullScreenScrollView.contentSize.width))
                
                let conditionTop = newHeight * fullScreenScrollView.zoomScale > (fullScreenPhoto?.frame.height)!
                
                let top = 0.5 * (conditionTop ? newHeight - (fullScreenPhoto?.frame.height)! : (scrollView.frame.height - fullScreenScrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        } else {
            fullScreenScrollView.contentInset = .zero
        }
    }
}
