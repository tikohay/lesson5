//
//  UserFriendsService.swift
//  VK
//
//  Created by Karahanyan Levon on 22.02.2021.
//

import Foundation
import Alamofire
import RealmSwift
import PromiseKit

class UserFriendsService {
    
    static let baseUrl = "https://api.vk.com"
    
    func saveUserData<T: Object>(_ usersData: [T]) {
        do {
            let realm = try Realm()
            let oldUsersData = realm.objects(T.self)
            realm.beginWrite()
            realm.delete(oldUsersData)
            
            realm.add(usersData)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func getUserPhoto(userId: Int) {
        
        let token = Session.instance.token
        print(token)
        let path = "/method/photos.get"
        let parameters: Parameters = [
            "access_token": token,
            "v": "5.130",
            "owner_id": userId,
            "album_id": "profile"
        ]
        
        let url = UserFriendsService.baseUrl + path
        Alamofire.request(url, method: .get, parameters: parameters).responseData { response in
            guard let data = response.value else { return }
            
            guard let photos = try? JSONDecoder().decode(PhotosResponse.self, from: data) else { return }
            
            self.saveUserData(photos.response.items)
        }
    }
    
    func getUserPhoto(userId: Int, completionHandler: @escaping ([PhotosClass]) -> Void) {
        
        let token = Session.instance.token
        let path = "/method/photos.get"
        let parameters: Parameters = [
            "access_token": token,
            "v": "5.130",
            "owner_id": userId,
            "album_id": "profile"
        ]
        
        let url = UserFriendsService.baseUrl + path
        Alamofire.request(url, method: .get, parameters: parameters).responseData { response in
            guard let data = response.value else { return }
            
            guard let photos = try? JSONDecoder().decode(PhotosResponse.self, from: data) else { return }
            
            completionHandler(photos.response.items)
        }
    }
    
    func getUserFriends() {
        
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
      
        Alamofire.request(url, method: .get, parameters: parameters).responseData { response in
            guard let data = response.value else { return }
            
            guard let friends = try? JSONDecoder().decode(FriendsResponse.self, from: data) else { return }
            
            self.saveUserData(friends.response.items)
        }
    }
    
    func getUserGroups() {
        
        let token = Session.instance.token
        let path = "/method/groups.get"
        let parameters: Parameters = [
            "access_token": token,
            "v": "5.130",
            "extended": "1"
        ]
        
        let url = UserFriendsService.baseUrl + path
        
        Promise<Data> { seal in
            Alamofire.request(url, method: .get, parameters: parameters).responseData { response in

                switch response.result {
                case .success(let data):
                    seal.fulfill(data)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }.then { data -> Promise<[GroupClass]> in
            
            do {
                let groups = try JSONDecoder().decode(GroupsResponse.self, from: data)
                
                return Promise.value(groups.response.items)
            } catch(let error) {
                throw error
            }
        }.done { groups in
            self.saveUserData(groups)
        }
    }
    
    func getUserSearchGroups(group name: String) {
        
        let token = Session.instance.token
        let path = "/method/groups.search"
        let parameters: Parameters = [
            "access_token": token,
            "q": name,
            "v": "5.130",
            "count": "20"
        ]
        
        let url = UserFriendsService.baseUrl + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseData { response in
            guard let data = response.value else { return }
            
            guard let availableGroups = try? JSONDecoder().decode(AvailableGroupsResponse.self, from: data) else { return }
            
            self.saveUserData(availableGroups.response.items)
        }
    }
    
    func getNews(startTime: Int? = nil, startFrom: Int? = nil, completionHandler: @escaping (NewsResponseInfo) -> Void) {
        
        let token = Session.instance.token
        let path = "/method/newsfeed.get"
        var parameters: Parameters = [
            "access_token": token,
            "v": "5.130",
            "count": "100"
        ]
        
        if startTime != nil {
            parameters["start_time"] = startTime
        }
        
        let url = UserFriendsService.baseUrl + path
        
        DispatchQueue.global(qos: .userInteractive).async {
            Alamofire.request(url, method: .get, parameters: parameters).responseData() { response in
                guard let data = response.value else { return }
                guard let newsData = try? JSONDecoder().decode(NewsResponse.self, from: data) else { return }
                
                let news = newsData.response
                
                completionHandler(news)
            }
        }
    }
}

