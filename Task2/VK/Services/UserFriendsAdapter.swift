//
//  UserFriendsAdapter.swift
//  VK
//
//  Created by Karahanyan Levon on 21.06.2021.
//

import Foundation
import RealmSwift

final class UserFriendsAdapter {
    
    private let userFriendsService = UserFriendsService()
    
    private var realmNotificationToken: NotificationToken?
    
    func getUserFriends(completionHandler: @escaping ([UserClass]) -> Void) {
        guard let realm = try? Realm() else { return }
        
        let token = realm.objects(UserClass.self).observe { (changes: RealmCollectionChange) in
            
            switch changes {
            case .update(let realmFriends, _, _, _):
                var friends: [UserClass] = []
            
                for realmFriend in realmFriends {
                    friends.append(realmFriend)
                }
                completionHandler(friends)
            case .error(let error):
                fatalError("\(error)")
            case .initial:
                break
            }
        }
        
        self.realmNotificationToken = token
        
        userFriendsService.getUserFriends()
    }
}
