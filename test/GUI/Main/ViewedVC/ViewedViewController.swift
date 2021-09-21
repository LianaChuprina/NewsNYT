//
//  ViewedViewController.swift
//  test
//
//  Created by Alexandr on 16.09.2021.
//

import UIKit
import Moya

final class ViewedViewController: ViewController {
    var articles = [ArticleResponse]()
    var presenter: PresenterViewed?
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(
                UINib(nibName: "\(ArticlTableViewCell.self)", bundle: nil),
                forCellReuseIdentifier: "\(ArticlTableViewCell.self)"
            )
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Most Viewed"
        
        presenter?.viewController = self
        presenter?.fetchViewedFeed()
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))

        activityIndicator.color = .black
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        tableView.addSubview(activityIndicator)
    }
    
    public func render(model: ViewModel) {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        articles = model.articles
        tableView.reloadData()
    }
}
// MARK: - UITableViewDelegate, UITableViewDataSource

extension ViewedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticlTableViewCell", for: indexPath) as? ArticlTableViewCell else { return UITableViewCell() }
        
        let imageUrl = (articles[indexPath.row].media.count > 0)
            ? articles[indexPath.row].media[0].mediaMetadata[2].url
            : nil
        cell.render(
            with: ArticlModel(
                title: articles[indexPath.row].title,
                time: articles[indexPath.row].updated,
                abstract: nil,
                imageURL: imageUrl,
                id: articles[indexPath.row].id,
                state: .favorite, url: articles[indexPath.row].url
            )
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var imageUrl: String?
        if self.articles[indexPath.row].media.count > 0,
           self.articles[indexPath.row].media[0].mediaMetadata.count == 3 {
            imageUrl = self.articles[indexPath.row].media[0].mediaMetadata[2].url
        }
        let newViewController =  ArticlesVC(
            model: ArticlModel(
                title: self.articles[indexPath.row].title,
                time: self.articles[indexPath.row].updated,
                abstract: self.articles[indexPath.row].abstract,
                imageURL: imageUrl,
                id: self.articles[indexPath.row].id,
                state: .favorite,
                url: self.articles[indexPath.row].url
                
            )
        )
        let myNavigationController = UINavigationController(rootViewController: newViewController)
        self.present(myNavigationController, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
}

extension ViewedViewController {
    private enum Constants {
        static let cellHeight: CGFloat = 150.0
    }
}




