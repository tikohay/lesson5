//
//  ButtonForDislike.swift
//  VK
//
//  Created by Karahanyan Levon on 26.01.2021.
//

import UIKit

class ButtonForDislike: UIControl {
    
    var countOfDislikeLabel = UILabel()
    var stackView = UIStackView()
    var dislikeButton = UIButton(type: .system)
    
    private let handThumbsdownImage = UIImage(systemName: "hand.thumbsdown")
    private let handThumbsupFillImage = UIImage(systemName: "hand.thumbsdown.fill")
    private var isDislike = false
    private var countOfDislike = 0
    
    func addButton() {
        dislikeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        
        if let image = handThumbsdownImage {
            dislikeButton.setImage(image, for: .normal)
        }
        
        dislikeButton.setTitleColor(.red, for: .normal)
        dislikeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(10))
        dislikeButton.tintColor = UIColor.mainBlueColor
        dislikeButton.addTarget(self, action: #selector(tappedDislike), for: .touchUpInside)
    }
    
    func addStackView() {
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 0
        stackView.addArrangedSubview(dislikeButton)
        stackView.addArrangedSubview(countOfDislikeLabel)
    }
    
    func setCountOfDislikeLabel() {
        countOfDislikeLabel.font = countOfDislikeLabel.font.withSize(15)
        countOfDislikeLabel.textColor = UIColor.mainBlueColor
    }
    
    @objc func tappedDislike(_ sender: UIButton) {
        isDislike.toggle()
        if isDislike {
            dislikeButton.setImage(handThumbsupFillImage, for: .normal)
            UIView.transition(with: countOfDislikeLabel,
                              duration: 0.3,
                              options: .transitionFlipFromBottom) {
                self.countOfDislikeLabel.text = "\(self.countOfDislike + 1)"
            }
            countOfDislike += 1
        } else {
            dislikeButton.setImage(handThumbsdownImage, for: .normal)
            UIView.transition(with: countOfDislikeLabel,
                              duration: 0.5,
                              options: .transitionCurlUp) {
                self.countOfDislikeLabel.text = ""
            }
            countOfDislike -= 1
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setCountOfDislikeLabel()
        addStackView()
        setCountOfDislikeLabel()
        self.addSubview(stackView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setCountOfDislikeLabel()
        addButton()
        addStackView()
        self.addSubview(stackView)
    }
}
