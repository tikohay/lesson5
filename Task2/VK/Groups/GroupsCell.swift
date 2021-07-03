//
//  GroupsCell.swift
//  VK
//
//  Created by Karahanyan Levon on 09.01.2021.
//

import UIKit

class GroupsCell: UITableViewCell {

    @IBOutlet weak var groupImageView: UIImageView? {
        didSet {
            guard let image = groupImageView else { return }
            image.layer.cornerRadius = image.frame.width / 2
        }
    }
    @IBOutlet weak var nameGroupLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func set(group: GroupClass, avatar: UIImage) {
        self.nameGroupLabel?.text = group.name
        self.groupImageView?.image = avatar
    }
}
