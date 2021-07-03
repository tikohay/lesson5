//
//  CommentsViewController.swift
//  VK
//
//  Created by Karahanyan Levon on 04.02.2021.
//

import UIKit

class CommentsViewController: UIViewController {
    
    var news: NewsItem?
    
    @IBOutlet weak var commentText: UITextView? {
        didSet {
            commentText?.layer.cornerRadius = 20
            commentText?.layer.borderWidth = 1
            commentText?.layer.borderColor = UIColor.black.cgColor
        }
    }
    @IBOutlet weak var commentButton: UIButton? {
        didSet {
            commentButton?.layer.cornerRadius = 10
        }
    }
    
    @IBAction func leaveComment(_ sender: UIButton) {
        performSegue(withIdentifier: "leaveComment", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
