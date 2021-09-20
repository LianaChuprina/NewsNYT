//
//  ViewedViewController.swift
//  test
//
//  Created by Alexandr on 16.09.2021.
//

import UIKit
import Moya

final class ViewedViewController: UIViewController {
    
    let providerViewed = MoyaProvider<Articles>()
    
    var articles = [ArticleResponse]()
    
    @IBOutlet private weak var tableView: UITableView! {
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
        
        fetchViewedFeed()
    }
    
    private func fetchViewedFeed() {
        providerViewed.request(.viewed) { result in
            print(result)
            switch result {
            case .success(let response):
                let articlsResponse = try? response.map(ArticlesRespose.self)
                self.articles = articlsResponse?.results ?? []
                self.articles.sort {
                    $0.updated.convertToDate()!.compare($1.updated.convertToDate()!) == .orderedDescending
                }
                self.tableView.reloadData()
            case .failure(let error):
                print(error.errorCode)
                print(error.errorDescription ?? "Unknown error")
            }
        }
    }
}
// MARK: - UITableViewDelegate, UITableViewDataSource

extension ViewedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticlTableViewCell", for: indexPath) as? ArticlTableViewCell
        else { return UITableViewCell() }
        
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
        
        let newViewController =  ArticlesVC()
        
        self.present(newViewController, animated: true, completion: nil)
        
        newViewController.render(
            model: ArticlModel(
                title: articles[indexPath.row].title,
                time: articles[indexPath.row].updated,
                abstract: articles[indexPath.row].abstract,
                imageURL:articles[indexPath.row].media[0].mediaMetadata[2].url,
                id: articles[indexPath.row].id,
                state: .favorite,
                url: articles[indexPath.row].url
            )
        )
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




