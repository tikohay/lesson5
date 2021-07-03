//
//  File.swift
//  VK
//
//  Created by Karahanyan Levon on 21.06.2021.
//

import Foundation

struct FriendCellViewModel {
    let name: String
    let starIconHidden: Bool
}

final class FriendCellViewModelFactory {
    
    func constructViewModel(from friend: UserClass) -> FriendCellViewModel {
        return self.viewModel(from: friend)
    }
    
    private func viewModel(from friend: UserClass) -> FriendCellViewModel {
        let name = friend.firstName + " " + friend.lastName
        let starIconHidden = !friend.isBestFriend
        
        return FriendCellViewModel(name: name, starIconHidden: starIconHidden)
    }
}
