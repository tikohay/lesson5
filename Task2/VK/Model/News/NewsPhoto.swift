//
//  NewsSize.swift
//  VK
//
//  Created by Karahanyan Levon on 01.05.2021.
//

import UIKit
import RealmSwift

class NewsPhoto: Object, Decodable {
    
    var sizes = List<NewsSize>()
    
    enum CodingKeys: String, CodingKey {
        case date
        case sizes
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.sizes = try values.decode(List<NewsSize>.self, forKey: .sizes)
    }
}
