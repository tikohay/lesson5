//
//  CustomTableViewCell.swift
//  VK
//
//  Created by Karahanyan Levon on 09.01.2021.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    static let identifier = "CustomTableViewCell"
    
    @IBOutlet weak var cellImage: UIImageView! {
        didSet {
            cellImage.layer.cornerRadius = cellImage.frame.width / 2
        }
    }
    @IBOutlet weak var cellLabel: UILabel!
   
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func set(label: String, imageName: UIImage) {
        cellLabel.text = label
        cellImage.image = imageName
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
