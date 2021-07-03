//
//  NewsResponseInfo.swift
//  VK
//
//  Created by Karahanyan Levon on 01.05.2021.
//

import Foundation

class NewsResponseInfo: Decodable {
    var groups: [NewsGroup]
    var items: [NewsItem]
}
