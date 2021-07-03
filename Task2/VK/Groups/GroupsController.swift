//
//  GroupsViewController.swift
//  VK
//
//  Created by Karahanyan Levon on 09.01.2021.
//

import UIKit
import RealmSwift

class GroupsController: UITableViewController {
    
    enum Cells {
        static let group = "groupsCell"
    }
    
    let userInfo = UserFriendsServiceProxy(service: UserFriendsService())
    var groupsDuplicate: [GroupClass] = []
    var groups: [GroupClass] = [] {
        didSet {
            groupsDuplicate = groups
        }
    }
    var groupObjects: Results<GroupClass>?
    var token: NotificationToken?
    
    var photoService: PhotoService?
    
    @IBOutlet var groupsTableView: UITableView?
    @IBOutlet weak var groupsSearchBar: UISearchBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userInfo.getUserGroups()
        loadData()
        
        changeSearchBarState()
        
        groupsSearchBar?.delegate = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        gesture.cancelsTouchesInView = false
        
        photoService = PhotoService(container: groupsTableView!)
        
        tableView.addGestureRecognizer(gesture)
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == "addGroup" {
            guard let availableGroupsController = segue.source as? AvailableGroups else { return }
            
            if let indexPath = availableGroupsController.tableView.indexPathForSelectedRow {
                
                let group = availableGroupsController.convertedGroup?[indexPath.row]

                if !groups.contains(where: {$0.name == group?.name && $0.imageName == group?.imageName}) {
                    guard let group = group else { return }
                    groups.append(group)
                    tableView.reloadData()
                }
            }
        }
    }

    func changeSearchBarState() {
        groupsSearchBar?.placeholder = "Search:"
    }
    
    func loadData() {
        
        guard let realm = try? Realm() else { return }
        
        self.groupObjects = realm.objects(GroupClass.self)
        
        token = groupObjects?.observe({ [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            
            switch changes {
            case .initial:
                tableView.reloadData()
                
            case .update:
                guard let groupsResults = self?.groupObjects else { return }
                    
                self?.groups = Array(groupsResults)
                
                tableView.reloadData()
                
            case .error(let error):
                fatalError("\(error)")
            }
        })
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsDuplicate.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.group, for: indexPath)
        guard let groupCell = cell  as? GroupsCell else { return cell }

        let group = groupsDuplicate[indexPath.row]

        guard let avatar = photoService?.photo(atIndexpath: indexPath, byUrl: group.imageName) else { return cell }
        
        groupCell.set(group: group, avatar: avatar)

        return groupCell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            groups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @objc func endEditing() {
        tableView.endEditing(true)
    }
}

extension GroupsController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        groupsDuplicate = groups
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        groupsDuplicate = searchText.isEmpty ? groups : groups.filter({ (group) -> Bool in
            return group.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        tableView.reloadData()
    }
}
