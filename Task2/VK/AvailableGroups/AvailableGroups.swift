//
//  AvailableGroupsController.swift
//  VK
//
//  Created by Karahanyan Levon on 09.01.2021.
//

import UIKit
import RealmSwift
import Firebase

class AvailableGroups: UITableViewController {
    
    enum Cells {
        static let availableGroup = "availableGroupCell"
    }
    
    var selectedGroup: AvailableGroupsClass?
    var userData = UserFriendsServiceProxy(service: UserFriendsService())
    var availableGroups: [AvailableGroupsClass] = [] {
        didSet {
            convertedGroup = availableGroups.map { GroupClass(value: $0) }
        }
    }
    var convertedGroup: [GroupClass]?
    var availableGroupObjects: Results<AvailableGroupsClass>?
    var token: NotificationToken?
    
    @IBOutlet var availableGroupsTableView: UITableView?
    @IBOutlet weak var availableGroupSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        changeSearchBarState()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
    }
    
    func changeSearchBarState() {
        availableGroupSearchBar.placeholder = "Search:"
        tableView.tableHeaderView = availableGroupSearchBar
    }
    
    func loadData() {
        guard let realm = try? Realm() else { return }
        
        self.availableGroupObjects = realm.objects(AvailableGroupsClass.self)
        
        token = availableGroupObjects?.observe({ [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update:
                guard let groupsResults = self?.availableGroupObjects else { return }
                    
                self?.availableGroups = Array(groupsResults)
                
                tableView.reloadData()
                
            case .error(let error):
                fatalError("\(error)")
            }
        })
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGroup = self.availableGroups[indexPath.row]
        
        addGroupToFirebaseCollection(selectedGroup)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableGroups.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.availableGroup, for: indexPath)
        guard let availableGroupCell = cell  as? AvailableGroupsCell else { return cell }

        let group = availableGroups[indexPath.row]

        availableGroupCell.set(availableGroup: group)

        return availableGroupCell
    }
    
    private func addGroupToFirebaseCollection(_ group: AvailableGroupsClass?) {
        guard let group = group else { return }
        
        let db = Firestore.firestore()

        db.collection("addedGroups").addDocument(data: [
            "id": group.groupId,
            "name": group.name
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            }
        }
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
}

extension AvailableGroups: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        availableGroups = []
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            availableGroups = []
            tableView.reloadData()
        } else {
            userData.getUserSearchGroups(group: searchText)
        }
    }
}
