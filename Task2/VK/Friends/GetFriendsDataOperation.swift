//
//  GetFriendsDataOperation.swift
//  VK
//
//  Created by Karahanyan Levon on 08.05.2021.
//

import UIKit
import RealmSwift
import Alamofire

class GetFriendsDataOperation: Operation {
    
    enum State: String {
        case ready, executing, finished
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    private var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    override func start() {
        if isCancelled {
            state = .finished
        } else {
            main()
            state = .executing
        }
    }
    
    override func cancel() {
        super.cancel()
        state = .finished
    }
    
    override func main() {
        
        let token = Session.instance.token
        print(token)
        let path = "/method/friends.get"
        let parameters: Parameters = [
            "access_token": token,
            "v": "5.130",
            "fields": "photo_200_orig",
            "count": "20"
        ]
        
        let url = UserFriendsService.baseUrl + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: DispatchQueue.global()) { response in
            guard let data = response.value else { return }
            
            guard let friends = try? JSONDecoder().decode(FriendsResponse.self, from: data) else { return }
            
            self.saveUserData(friends.response.items)
            self.state = .finished
        }
    }
    
    func saveUserData(_ usersData: [UserClass]) {
        do {
            let realm = try Realm()
            let oldUsersData = realm.objects(UserClass.self)
            realm.beginWrite()
            realm.delete(oldUsersData)
            
            realm.add(usersData)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
}
