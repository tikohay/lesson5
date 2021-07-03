//
//  UserFriendsServiceProxy.swift
//  VK
//
//  Created by Karahanyan Levon on 03.07.2021.
//

import Foundation
import RealmSwift

class UserFriendsServiceProxy {
    
    var service: UserFriendsService
    
    init(service: UserFriendsService) {
        self.service = service
    }
    
    func saveUserData<T: Object>(_ usersData: [T]) {
        print("[UserFriendsServiceProxy] saveUserData")
        service.saveUserData(usersData)
    }
    
    func getUserPhoto(userId: Int) {
        print("[UserFriendsServiceProxy] getUserPhoto")
        service.getUserPhoto(userId: userId)
    }
    
    func getUserPhoto(userId: Int, completionHandler: @escaping ([PhotosClass]) -> Void) {
        print("[UserFriendsServiceProxy] getUserPhoto")
        service.getUserPhoto(userId: userId, completionHandler: completionHandler)
    }
    
    func getUserFriends() {
        print("[UserFriendsServiceProxy] getUserFriends")
        service.getUserFriends()
    }
    
    func getUserGroups() {
        print("[UserFriendsServiceProxy] getUserGroups")
        service.getUserGroups()
    }
    
    func getUserSearchGroups(group name: String) {
        print("[UserFriendsServiceProxy] getUserSearchGroups")
        service.getUserSearchGroups(group: name)
    }
    
    func getNews(startTime: Int? = nil, startFrom: Int? = nil, completionHandler: @escaping (NewsResponseInfo) -> Void) {
        print("[UserFriendsServiceProxy] getNews")
        service.getNews(startTime: startTime, startFrom: startFrom, completionHandler: completionHandler)
    }
}
