//
//  PhotoFriendController.swift
//  VK
//
//  Created by Karahanyan Levon on 12.01.2021.
//

import UIKit
import RealmSwift

class PhotoFriendController: UIViewController {
    
    enum Cells {
        static let identifier = "PhotoFriendCell"
    }
    
    var photosData = UserFriendsService()
    var user: UserClass?
    var photos: Results<PhotosClass>?
    var token: NotificationToken?
    
    @IBOutlet weak var photosCollectionView: UICollectionView?
    @IBOutlet var photoFriendContentView: UICollectionView?
    @IBOutlet weak var friendAvatarImage: UIImageView?
    @IBOutlet weak var friendNameLabel: UILabel?
    
    private let itemsPerRow: CGFloat = 2
    private let sectionInserts = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        photosData.getUserPhoto(userId: user?.userId ?? -1)
        loadData()
        
        self.friendNameLabel?.text = user?.firstName
        UIImageView.getPhoto(from: user?.avatarName ?? "", imageView: self.friendAvatarImage!)
        photoFriendContentView?.collectionViewLayout = UICollectionViewFlowLayout()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFullScreenVC" {
            let photoVC = segue.destination as! FullScreenViewController
            photoVC.imageNames = (sender as? [PhotosClass])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let photos = photos else { return }
        performSegue(withIdentifier: "toFullScreenVC", sender: Array(photos))
    }
    
    func loadData() {
        
        guard let realm = try? Realm() else { return }
        self.photos = realm.objects(PhotosClass.self)
        
        token = photos?.observe{ [weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.photosCollectionView else { return }
            
            switch changes {
            case .initial, .update:
                collectionView.reloadData()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
}

extension PhotoFriendController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let photos = self.photos else { return 0 }
        
        print(photos.count)
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.identifier, for: indexPath)
        guard let photoCell = cell as? PhotoOfFriendCell,
              let photos = photos else { return cell }

        UIImageView.getPhoto(from: photos[indexPath.item].urlImage, imageView: photoCell.friendImage!)

        return photoCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingWidth = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
}


