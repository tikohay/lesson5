//
//  SectionIndexTitlesControll.swift
//  VK
//
//  Created by Karahanyan Levon on 31.01.2021.
//

import UIKit

class SectionIndexTitlesControll: UIControl {
    
    var selectedLetter: Character? = nil {
        didSet {
            self.sendActions(for: .valueChanged)
        }
    }
    
    private var labels: [UILabel] = []
    private var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addObservers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        addObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(FriendViewController.gotUserFriendsNotification)
    }
    
    private func setupView() {
        
        backgroundColor = .clear

        createLabels()
        
        stackView = UIStackView(arrangedSubviews: labels)
        
        addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
    }
    
    func createLabels() {
        for letter in usersFirstLetters {
            let label = UILabel()

            label.text = String(letter)
            label.font = label.font.withSize(11)

            addPanGestureRecognizer()

            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognizer(_:)))
            label.addGestureRecognizer(gestureRecognizer)
            label.isUserInteractionEnabled = true

            labels.append(label)
        }
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(createLettersControll),
                                               name: FriendViewController.gotUserFriendsNotification,
                                               object: nil)
    }
    
    @objc func createLettersControll() {
        setupView()
    }
    
    @objc func tapRecognizer(_ sender: UITapGestureRecognizer) {
        guard let text = (sender.view as? UILabel)?.text else { return }
        
        selectedLetter = Character(text)
    }

    private func addPanGestureRecognizer() {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        self.addGestureRecognizer(recognizer)
    }

    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        
        switch recognizer.state {
        case .began, .changed, .ended:
            let location = recognizer.location(in: self)
            let targetView = hitTest(location, with: nil)
            
            if let label = targetView as? UILabel {
                
                if Character(label.text ?? "") != selectedLetter {
                    selectedLetter = Character(label.text ?? "")
                }
            }
            
        default:
            return
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
}
