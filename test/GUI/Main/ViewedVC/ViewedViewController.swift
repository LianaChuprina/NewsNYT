//
//  ViewedViewController.swift
//  test
//
//  Created by Alexandr on 16.09.2021.
//

import UIKit
import Moya

class ViewedViewController: UIViewController {

    let providerViewed = MoyaProvider<Articles>()
   
    var articles = [ArticleResponse]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ArticlTableViewCell",
                                       bundle: nil),
                                 forCellReuseIdentifier: "ArticlTableViewCell")
        
        providerViewed.request(.viewed) { result in
            print(result)
            switch result {
            case .success(let response):
                let articlsResponse = try? response.map(ArticlesRespose.self)
                self.articles = articlsResponse?.results ?? []
                self.articles.sort {$0.updated.convertToDate()!.compare($1.updated.convertToDate()!) == .orderedDescending}
                self.tableView.reloadData()
            case .failure(let error):
                print(error.errorCode)
                print(error.errorDescription ?? "Unknown error")
            }
        }
    }
}

extension ViewedViewController: UITableViewDelegate,
                                UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
                        state: .favorite, url: articles[indexPath.row].url))}
        else {
            cellGood.render(with:
                        ArticlModel(title: articles[indexPath.row].title,
                        time:articles[indexPath.row].updated,
                        abstract: nil, imageURL: "",
                        id: articles[indexPath.row].id,
                        state: .favorite, url: articles[indexPath.row].url))
        }
            return cellGood
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {

       let newViewController =  ArticlesVC()
        
        self.present(newViewController,
                     animated: true,
                     completion: nil)
        newViewController.render(model: ArticlModel(
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




