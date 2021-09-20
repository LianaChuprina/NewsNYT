//
//  HomeViewController.swift
//  test
//
//  Created by Alexandr on 16.09.2021.
//

import UIKit
import Moya

final class HomeViewController: UIViewController {
    
    let provider = MoyaProvider<Articles>()
    
    @IBOutlet weak var actuvityIndicator: UIActivityIndicatorView!
    var articles = [ArticleResponse]()
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Most News"
        
        actuvityIndicator.color = .black
        actuvityIndicator.isHidden = false
        actuvityIndicator.startAnimating()
        tableView.addSubview(actuvityIndicator)
        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(
            UINib(nibName: "\(ArticlTableViewCell.self)", bundle: nil),
            forCellReuseIdentifier: "\(ArticlTableViewCell.self)"
        )
        
        provider.request(.shared) { result in
            print(result)
            self.actuvityIndicator.isHidden = true
            self.actuvityIndicator.stopAnimating()
            switch result {
            case .success(let response):
                let articlsResponse = try? response.map(ArticlesResponse.self)
                self.articles = articlsResponse?.results ?? []
                self.articles.sort { $0.updated.convertToDate()!.compare($1.updated.convertToDate()!) == .orderedDescending }
                self.tableView.reloadData()
            case .failure(let error):
                print(error.errorCode)
                print(error.errorDescription ?? "Unknown error")
            }
        }
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticlTableViewCell",
                                                 for: indexPath)
        
        if let cellGood = cell as? ArticlTableViewCell {
            if articles[indexPath.row].media.count != 0 {
                cellGood.render(
                    with: ArticlModel(
                        title: articles[indexPath.row].title,
                        time: articles[indexPath.row].updated,
                        abstract: nil,
                        imageURL: articles[indexPath.row].media[0].mediaMetadata[2].url,
                        id: articles[indexPath.row].id,
                        state: .favorite,
                        url: articles[indexPath.row].url
                    )
                )
            } else {
                cellGood.render(
                    with: ArticlModel(
                        title: articles[indexPath.row].title,
                        time: articles[indexPath.row].updated,
                        abstract: nil,
                        imageURL: "",
                        id: articles[indexPath.row].id,
                        state: .favorite,
                        url: articles[indexPath.row].url
                    )
                )
            }
            return cellGood
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newViewController =  ArticlesVC(
            model: ArticlModel(
            title: self.articles[indexPath.row].title,
            time: self.articles[indexPath.row].updated,
            abstract: self.articles[indexPath.row].abstract,
            imageURL: self.articles[indexPath.row].media[0].mediaMetadata[2].url,
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

extension HomeViewController {
    private enum Constants {
        static let cellHeight: CGFloat = 150.0
    }
}

