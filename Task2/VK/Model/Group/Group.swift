//
//  Group.swift
//  VK
//
//  Created by Karahanyan Levon on 09.01.2021.
//

import UIKit
import RealmSwift

class GroupClass: Object, Decodable {
    @objc dynamic var name = ""
    @objc dynamic var imageName = ""
    @objc dynamic var groupId = 0
    
    enum CodingKeys: String, CodingKey {
        case imageName = "photo_200"
        case name
        case groupId = "id"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try values.decode(String.self, forKey: .name)
        self.imageName = try values.decode(String.self, forKey: .imageName)
        self.groupId = try values.decode(Int.self, forKey: .groupId)
    }
}
