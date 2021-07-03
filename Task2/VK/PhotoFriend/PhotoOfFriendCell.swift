//
//  PhotoOfFriendCell.swift
//  VK
//
//  Created by Karahanyan Levon on 12.01.2021.
//

import UIKit

class PhotoOfFriendCell: UICollectionViewCell {
    
    @IBOutlet var dislikeButtonSubview: ButtonForDislike?
    @IBOutlet weak var friendImage: UIImageView?
    @IBOutlet weak var likeCountLabel: UILabel? {
        didSet {
            likeCountLabel?.textColor = .red
        }
    }
    @IBOutlet weak var likeButton: UIButton? {
        didSet {
            likeButton?.tintColor = UIColor.mainBlueColor
            addDoubleTapForLike()
        }
    }
    
    private var isLike = false
    private var numOfLike = 0
    
    @IBAction func likeButtonClicked(_ sender: UIButton) {
        changeNumOfLikes()
        changeLikeState()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    private func changeNumOfLikes() {
        if !isLike {
            numOfLike += 1
            UIView.transition(with: likeCountLabel!,
                              duration: 0.3,
                              options: .transitionFlipFromBottom) {
                self.likeCountLabel?.text = "\(self.numOfLike)"
            }
        } else {
            UIView.transition(with: likeCountLabel!,
                              duration: 0.5,
                              options: .transitionCurlUp) {
                self.likeCountLabel!.text = ""
            }
            numOfLike -= 1
        }
        isLike.toggle()
    }
    
    private func changeLikeState() {
        if numOfLike > 0 {
            self.likeButton?.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            self.likeButton?.tintColor = .red
            self.likeButton?.setTitleColor(.red, for: .normal)
            self.likeButton?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            
        } else {
            self.likeButton?.setImage(UIImage(systemName: "heart"), for: .normal)
            self.likeButton?.tintColor = UIColor.mainBlueColor
            }
    }
    
    func addDoubleTapForLike() {
        let doubleTapForLike = UITapGestureRecognizer(target: self, action: #selector(tapedForLike))
        doubleTapForLike.numberOfTapsRequired = 2
        friendImage?.addGestureRecognizer(doubleTapForLike)
        friendImage?.isUserInteractionEnabled = true
    }
    
    @objc func tapedForLike() {
        changeNumOfLikes()
        changeLikeState()
    }
}
