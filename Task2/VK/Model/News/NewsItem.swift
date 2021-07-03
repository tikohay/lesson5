//
//  NewsItem.swift
//  VK
//
//  Created by Karahanyan Levon on 01.05.2021.
//

import UIKit
import RealmSwift

class NewsItem: Object, Decodable {
    
    @objc dynamic var text: String? = ""
    @objc dynamic var date: Int = 0
    @objc dynamic var sourceId = 0
    @objc dynamic var type = ""
    var attachments: [NewsAttachment]? = []
    
    enum CodingKeys: String, CodingKey {
        case text
        case attachments
        case date
        case source_id = "source_id"
        case type
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try values.decodeIfPresent(String.self, forKey: .text)
        self.attachments = try values.decodeIfPresent([NewsAttachment].self, forKey: .attachments)
        self.date = try values.decode(Int.self, forKey: .date)
        self.sourceId = try values.decode(Int.self, forKey: .source_id)
        self.type = try values.decode(String.self, forKey: .type)
    }
}
