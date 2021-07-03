//
//  NewsSizes.swift
//  VK
//
//  Created by Karahanyan Levon on 01.05.2021.
//

import UIKit
import RealmSwift

class NewsSize: Object, Decodable {
    
    @objc dynamic var url: String = ""
    
    enum CodingKeys: String, CodingKey {
        case url
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try values.decode(String.self, forKey: .url)
    }
}
