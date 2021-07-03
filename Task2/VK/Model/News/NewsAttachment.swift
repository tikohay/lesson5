//
//  NewsAttachment.swift
//  VK
//
//  Created by Karahanyan Levon on 01.05.2021.
//

import UIKit
import RealmSwift

class NewsAttachment: Object, Decodable {
    
    @objc dynamic var photo: NewsPhoto?
    
    enum CodingKeys: String, CodingKey {
        case photo
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.photo = try values.decodeIfPresent(NewsPhoto.self, forKey: .photo)
    }
}
