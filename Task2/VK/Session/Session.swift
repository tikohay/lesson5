//
//  Session.swift
//  VK
//
//  Created by Karahanyan Levon on 20.02.2021.
//

import Foundation

class Session {
    
    static let instance = Session()
    
    private init() {}
    
    var token = ""
    var userId = 0
}
