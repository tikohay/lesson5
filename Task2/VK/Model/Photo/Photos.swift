//
//  Photos.swift
//  VK
//
//  Created by Karahanyan Levon on 09.03.2021.
//

import Foundation
import RealmSwift

class PhotosClass: Object, Decodable {
    @objc dynamic var userId = 0
    @objc dynamic var urlImage = ""
    var imageNames = List<String>()
    var date = 0
    
    enum CodingKeys: String, CodingKey {
        case userId = "owner_id"
        case sizes
        case date
    }
    
    enum UrlKeys: String, CodingKey {
        case url
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try values.decode(Int.self, forKey: .userId)
        self.date = try values.decode(Int.self, forKey: .date)
        var sizes = try values.nestedUnkeyedContainer(forKey: .sizes)
        var lastUrlValue = try sizes.nestedContainer(keyedBy: UrlKeys.self)
        
        while !sizes.isAtEnd {
            lastUrlValue = try sizes.nestedContainer(keyedBy: UrlKeys.self)
        }
        
        self.urlImage = try lastUrlValue.decode(String.self, forKey: .url)
        self.imageNames.append(urlImage)
    }
}
