//
//  dataForSectionIndexTitles.swift
//  VK
//
//  Created by Karahanyan Levon on 29.01.2021.
//

import Foundation

var usersFirstLetters: [Character] {
    var letters: Set<Character> = []
    
    for name in FriendViewController.allUsers {
        guard let firstLetter = name.firstName.first else { continue }
        letters.insert(firstLetter)
    }
    return letters.sorted()
}
