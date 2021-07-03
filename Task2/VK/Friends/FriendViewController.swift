//
//  FriendViewController.swift
//  VK
//
//  Created by Karahanyan Levon on 22.01.2021.
//

import UIKit
import RealmSwift

class FriendViewController: UIViewController {
    
    private let viewModelFactory = FriendCellViewModelFactory()
    
    var usersDict: [Character: [UserClass]] = [:]
    var usersFirstLetters: [Character] = []
    static var allUsers: [UserClass] = []
    
    var friends: Results<UserClass>?
    var token: NotificationToken?
    
    var photoService: PhotoService?
    
    let operationQueue = OperationQueue()
    
    static let gotUserFriendsNotification = Notification.Name("gotUserFriendsNotification")
    
    let userData = UserFriendsServiceProxy(service: UserFriendsService())
    
    private let userFriendsService = UserFriendsAdapter()
    
    var usersDuplicate: [UserClass] = [] {
        didSet {
            createUsersDict()
            usersFirstLetters = usersDict.keys.sorted()
        }
    }
    
    @IBOutlet weak var friendSearchBar: UISearchBar?
    @IBOutlet weak var friendsTableView: UITableView?
    @IBOutlet weak var sectionIndexTitlesView: SectionIndexTitlesControll?
    
    func changeSearchBarState() {
        friendSearchBar?.placeholder = "Search:"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeSearchBarState()
        
        friendsTableView?.showsVerticalScrollIndicator = false
        
        userFriendsService.getUserFriends { [weak self] friends in
            guard let tableView = self?.friendsTableView else { return }
            
            self?.usersDuplicate = Array(friends)
            tableView.reloadData()
        }
        
        let friendOperation = GetFriendsDataOperation()
        
        photoService = PhotoService(container: friendsTableView!)
        
        operationQueue.addOperation(friendOperation)
        
        sectionIndexTitlesView?.addTarget(self, action: #selector(sectionLetterChanged), for: .valueChanged)
        friendsTableView?.register(UINib(nibName: "HeaderXib", bundle: nil), forHeaderFooterViewReuseIdentifier: "Header")
        
        friendSearchBar?.delegate = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        gesture.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(gesture)
    }
    
    func loadData() {
        guard let realm = try? Realm() else { return }
        
        self.friends = realm.objects(UserClass.self)
        token = friends?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.friendsTableView else { return }
            
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update:
                guard let friendsResults = self?.friends else { return }
                
                self?.usersDuplicate = Array(friendsResults)
                tableView.reloadData()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    @objc func sectionLetterChanged() {
        
        guard let letter = sectionIndexTitlesView?.selectedLetter else { return }
        guard let letterIndex = usersFirstLetters.firstIndex(of: letter) else { return }
        
        friendsTableView?.scrollToRow(at: IndexPath(row: 0, section: letterIndex), at: .top, animated: true)
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
    
    private func createUsersDict() {
        usersDict = [:]
        
        for user in usersDuplicate {
            guard let firstLetter = user.firstName.first else { continue }
            
            if var userValues = usersDict[firstLetter] {
                userValues.append(user)
                usersDict[firstLetter] = userValues
            } else {
                usersDict[firstLetter] = [user]
            }
        }
    }
}

extension FriendViewController: UITableViewDelegate {
    
}

extension FriendViewController: UITableViewDataSource {
    
    enum Segues {
        static let toPhoto = "ToPhotoController"
    }
    
    enum Cells {
        static let friend = "friendsCell"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return usersFirstLetters.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let letter = usersFirstLetters[section]
        
        return usersDict[letter]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as! HeaderView
        header.headerLabel?.text = String(usersFirstLetters[section])
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.friend, for: indexPath)
        guard let friendCell = cell as? FriendsCell else { return cell }
        
        let user = getUserFromDict(indexPath)
        
        guard let avatar = photoService?.photo(atIndexpath: indexPath, byUrl: user.avatarName) else { return cell }
        
        let viewModel = viewModelFactory.constructViewModel(from: user)
        
        friendCell.set(user: viewModel, avatar: avatar)
        
        return friendCell
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == Segues.toPhoto {
//            guard let destVC = segue.destination as? PhotoFriendController else { return }
//            destVC.user = sender as? UserClass
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = getUserFromDict(indexPath)
        let toVC = ASPhotosViewController()
        toVC.userId = user.userId
        toVC.titleText = user.firstName + " " + user.lastName
        navigationController?.pushViewController(toVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let bestFriendAction = getMyBestFriendAction(at: indexPath)
        
        return UISwipeActionsConfiguration(actions: [bestFriendAction])
    }
    
    func getMyBestFriendAction(at indexPath: IndexPath) -> UIContextualAction {
        
        let user = getUserFromDict(indexPath)
        let letter = usersFirstLetters[indexPath[0]]
        
        guard var usersArray = usersDict[letter] else { return UIContextualAction() }
        
        let action = UIContextualAction(style: .normal, title: "best friend") { (action, view, completion) in
            
            user.isBestFriend.toggle()
            
            usersArray.remove(at: indexPath.row)
            
            if user.isBestFriend {
                usersArray.insert(user, at: 0)
            } else {
                usersArray.append(user)
            }
            self.usersDict[letter] = usersArray
            
            self.friendsTableView?.reloadData()
            completion(true)
        }
        
        if user.isBestFriend {
            action.image = UIImage(systemName: "star.slash")
            action.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            action.image = UIImage(systemName: "star")
            action.backgroundColor = UIColor.mainBlueColor
        }
        return action
    }
    
    private func getUserFromDict(_ indexPath: IndexPath) -> UserClass {
        
        let letter = usersFirstLetters[indexPath[0]]
        let usersArray = usersDict[letter]
        let user = usersArray![indexPath[1]]
        
        return user
    }
}

extension FriendViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        usersDuplicate = FriendViewController.allUsers
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            sectionIndexTitlesView?.isHidden = false
            usersDuplicate = FriendViewController.allUsers
        } else {
            sectionIndexTitlesView?.isHidden = true
            usersDuplicate = FriendViewController.allUsers.filter({ (user) -> Bool in
                return user.firstName.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            })
        }
        friendsTableView?.reloadData()
    }
}
