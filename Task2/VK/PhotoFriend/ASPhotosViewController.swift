//
//  ASPhotosViewController.swift
//  VK
//
//  Created by Karahanyan Levon on 02.06.2021.
//

import UIKit
import AsyncDisplayKit

class ASPhotosViewController: ASDKViewController<ASDisplayNode>, ASCollectionDelegate, ASCollectionDataSource {
    
    let vkService = UserFriendsServiceProxy(service: UserFriendsService())
    var totalPhotos: [PhotosClass] = []
    var nextFrom: String?
    var lastRefreshed: Date?
    var titleText: String? {
        didSet {
            self.title = titleText
        }
    }
    var userId: Int? {
        didSet {
            fetchData()
        }
    }
    
    var collectionNode: ASCollectionNode {
        return node as! ASCollectionNode
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    override init() {
        let flowLayout = UICollectionViewFlowLayout()
        
        super.init(node: ASCollectionNode(collectionViewLayout: flowLayout))
        
        collectionNode.collectionViewLayout = flowLayout
        
        
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 1
        
        self.collectionNode.delegate = self
        self.collectionNode.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fetchData() {
        vkService.getUserPhoto(userId: userId ?? 0) { photos in
            self.totalPhotos = photos
            self.collectionNode.reloadData()
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let toVC = storyboard.instantiateViewController(withIdentifier: "FullScreenID") as! FullScreenViewController
        toVC.imageNames = totalPhotos
        toVC.currentImageIndex = indexPath.row
        toVC.modalPresentationStyle = .formSheet
        present(toVC, animated: true)
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return totalPhotos.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        
        let photo = totalPhotos[indexPath.row]
        
        let cellNodeBlock = { () -> ASCellNode in
            let node = ASPhotoCell(resource: photo)
            return node
        }
        
        return cellNodeBlock
    }
}

extension ASPhotosViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 120, height: 120)
    }
}
