//
//  NewsTableViewCell.swift
//  VK
//
//  Created by Karahanyan Levon on 04.02.2021.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    var commentText: String?
    var isLike = false
    var likeCount = 0
    
    let readmoreFont = UIFont(name: "Helvetica-Oblique", size: 11.0)
    let readmoreFontColor = UIColor.black
    
    @IBOutlet weak var newsTextScrollView: UIScrollView?
    @IBOutlet weak var newsLogoImage: UIImageView? {
        didSet {
            guard let imageWidth = newsLogoImage?.frame.width else { return }
            newsLogoImage?.layer.cornerRadius = imageWidth / 2
        }
    }
    @IBOutlet weak var newsNameLabel: UILabel?
    @IBOutlet weak var newsImage: UIImageView?
    @IBOutlet weak var newsTextLabel: UILabel?
    @IBOutlet weak var commentsLabel: UILabel?
    @IBOutlet weak var likeButton: UIButton?
    @IBOutlet weak var commentButton: UIButton?
    @IBOutlet weak var readButton: UIButton?
    @IBOutlet weak var labelHeightAnchor: NSLayoutConstraint?
    
    var isReaded = false {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBAction func likeTapped(_ sender: UIButton) {
        if !isLike {
            likeCount += 1
            likeButton?.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeButton?.tintColor = .red
            likeButton?.setTitleColor(.red, for: .normal)
            likeButton?.setTitle(" \(likeCount)", for: .normal)
        } else {
            likeButton?.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton?.tintColor = UIColor.mainBlueColor
            likeButton?.setTitle("", for: .normal)
            likeCount -= 1
        }
        isLike.toggle()
    }
    
    @IBAction func commentTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func readButtonTapped(_ sender: UIButton) {
        if !isReaded {
            newsLabelFrame()
            readButton?.setTitle("Read less", for: .normal)
            isReaded.toggle()
        } else {
            newsLabelFrame()
            readButton?.setTitle("Read more", for: .normal)
            isReaded.toggle()
        }
    }
    
    func set(newsMain: NewsGroup, newsFill: NewsItem) {
        UIImageView.getPhoto(from: newsFill.attachments?.first?.photo?.sizes.last?.url ?? "", imageView: newsImage!)
        UIImageView.getPhoto(from: newsMain.image, imageView: newsLogoImage!)
        newsNameLabel?.text = newsMain.name
        newsTextLabel?.text = newsFill.text
        
        checkIfNeededReadButton()
    }
    
    func getLabelSize(text: String, font: UIFont) -> CGFloat {
        
        let maxWidth = textLabel!.frame.width
        
            let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
            let width = Double(rect.size.width)
            let height = Double(rect.size.height)
            let size = CGSize(width: ceil(width), height: ceil(height))
        return size.height
    }
    
    private func checkIfNeededReadButton() {
        guard
            let text = newsTextLabel?.text,
            let font = newsTextLabel?.font
        else { return }
        
        let height = getLabelSize(text: text, font: font)
        
        if height > CGFloat(100) {
            readButton?.isHidden = false
        } else {
            readButton?.isHidden = true
        }
    }
    
    private func newsLabelFrame() {
        guard
            let text = newsTextLabel?.text,
            let font = newsTextLabel?.font
        else { return }
        
        let height = getLabelSize(text: text, font: font)
        
        if !isReaded {
            labelHeightAnchor?.constant = 100
        } else {
            labelHeightAnchor?.constant = height
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commentsLabel?.text = commentText
        newsTextScrollView?.showsVerticalScrollIndicator = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        newsLabelFrame()
    }
}
