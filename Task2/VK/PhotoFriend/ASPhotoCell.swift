//
//  ASPhotoCell.swift
//  VK
//
//  Created by Karahanyan Levon on 02.06.2021.
//

import UIKit
import AsyncDisplayKit

class ASPhotoCell: ASCellNode {
    private let resource: PhotosClass
    private let photoImageNode = ASNetworkImageNode()
    
    init(resource: PhotosClass) {
        self.resource = resource
        super.init()
        setupSubnodes()
    }
    
//    override init(viewControllerBlock: @escaping ASDisplayNodeViewControllerBlock, didLoad didLoadBlock: ASDisplayNodeDidLoadBlock? = nil) {
//        
//    }
    
    private func setupSubnodes() {
        addSubnode(photoImageNode)
        
        photoImageNode.url = URL(string: resource.urlImage)
        photoImageNode.contentMode = .scaleAspectFill
        photoImageNode.shouldRenderProgressImages = true
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let width = constrainedSize.max.width
        photoImageNode.style.preferredSize = CGSize(width: width, height: width)
        return ASWrapperLayoutSpec(layoutElement: photoImageNode)
    }
}
