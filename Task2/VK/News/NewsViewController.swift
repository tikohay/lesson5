//
//  NewsViewController.swift
//  VK
//
//  Created by Karahanyan Levon on 03.02.2021.
//

import UIKit

class NewsViewController: UIViewController {
    
    var commentLabel: String?
    
    var news: NewsResponseInfo?
    var userData = UserFriendsServiceProxy(service: UserFriendsService())
    
    var nextFrom = 0
    var isLoading = false
    
    var refreshControl: UIRefreshControl?
    
    @IBOutlet weak var newsTableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshControl()
        
        newsTableView?.dataSource = self
        newsTableView?.delegate = self
        
        newsTableView?.prefetchDataSource = self
        
        newsTableView?.register(UINib(nibName: "NewsCustomCellXib", bundle: nil), forCellReuseIdentifier: "Cell")
        
        self.userData.getNews { news in
            DispatchQueue.main.async {
                self.news = news
                self.newsTableView?.reloadData()
            }
        }
    }
    
    fileprivate func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        
        refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing...")
        refreshControl?.tintColor = .blue
        refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
        
        newsTableView?.refreshControl = refreshControl
    }
    
    @objc func refreshNews() {
        refreshControl?.beginRefreshing()
        
        let mostFreshNewsDate = news?.items.first?.date ?? Int(Date().timeIntervalSince1970)
        
        userData.getNews(startTime: mostFreshNewsDate + 1) { [weak self] news in
            
            guard let self = self else { return }
            
            self.refreshControl?.endRefreshing()
            
            guard news.items.count > 0 else { return }
            
            self.news?.items = news.items + (self.news?.items ?? [])
            
            self.newsTableView?.reloadData()
        }
    }
    
    @IBAction func returnToNewsController(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func returnAndLeaveCommentToNewsController(segue: UIStoryboardSegue) {
        guard segue.identifier == "leaveComment" else { return }
        let commentController = segue.source as? CommentsViewController
        let commentText = commentController?.commentText?.text
        commentLabel = commentText
        newsTableView?.reloadData()
    }
}

extension NewsViewController: UITableViewDelegate {
    
}

extension NewsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        guard let newsCell = cell as? NewsTableViewCell else { return cell }
        
        guard let newsFill = news?.items[indexPath.row] else { return cell}
        
        var newsSource: NewsGroup
        let defaultNewsGroup = NewsGroup()
        
        defaultNewsGroup.name = "test"
        
        if newsFill.type == "post" {
            newsSource = news?.groups.first(where: { newsGroup in
                return newsGroup.id == (newsFill.sourceId * -1)
            }) ?? defaultNewsGroup
        } else {
            newsSource = defaultNewsGroup
        }
        
        newsCell.set(newsMain: newsSource, newsFill: newsFill)
        newsCell.commentButton?.addTarget(self, action: #selector(tapCommentButton), for: .touchUpInside)
        newsCell.commentsLabel?.text = commentLabel
        
        return cell
    }
    
    @objc func tapCommentButton() {
        performSegue(withIdentifier: "toCommentsView", sender: nil)
    }
}

extension NewsViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        guard
            let maxRow = indexPaths.map( { $0.row } ).max(),
            let newsItems = news?.items
        else { return }
        
        if maxRow > newsItems.count - 3, !isLoading {
            isLoading = true
            userData.getNews(startFrom: self.nextFrom) { [weak self] news in
                
                guard let self = self else { return }
                
                self.news?.items.append(contentsOf: news.items)
                
                self.newsTableView?.reloadData()
                self.isLoading = false
            }
        }
    }
}
