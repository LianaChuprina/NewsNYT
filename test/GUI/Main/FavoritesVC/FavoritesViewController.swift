//
//  FavoritesViewController.swift
//  test
//
//  Created by Alexandr on 16.09.2021.
//

import Foundation
import Moya
import CoreData

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var articles = [ArticlesCD]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "\(ArticlTableViewCell.self)", bundle: nil),
                           forCellReuseIdentifier: "\(ArticlTableViewCell.self)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchArticles()
    }
    
    private func fetchArticles() {
        let context = NSManagedObjectContext.getContext()
        let fetchRequest: NSFetchRequest<ArticlesCD> = ArticlesCD.fetchRequest()
        do {
            articles = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticlTableViewCell",
                                                 for: indexPath)
        if let cellGood = cell as? ArticlTableViewCell {
            cellGood.render(
                with: ArticlModel(
                    title: articles[indexPath.row].title ?? "",
                    time: articles[indexPath.row].updatedTime ?? "",
                    abstract: nil,
                    imageURL: articles[indexPath.row].imageURL,
                    id: Int(articles[indexPath.row].id),
                    state: .favorite,
                    url: articles[indexPath.row].url ?? ""
                )
            )
            return cellGood
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newViewController =  ArticlesVC()
        self.present(newViewController,
                     animated: true,
                     completion: nil)
        
        newViewController.render(
            model: ArticlModel(
                title: articles[indexPath.row].title ?? "",
                time: articles[indexPath.row].updatedTime ?? "",
                abstract: articles[indexPath.row].abstract,
                imageURL: nil,
                id: Int(articles[indexPath.row].id),
                state: .delete,
                url: articles[indexPath.row].url ?? ""
            )
        )
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { [self] (action, view, comletionHandler) in
            let cellToRemove = articles[indexPath.row]
            let ArticlViewController = ArticlesVC()
            ArticlViewController.someFunc(cellToRemove: cellToRemove)
            articles.remove(at: indexPath.row)
            tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}

extension FavoritesViewController {
    private enum Constants {
        static let cellHeight: CGFloat = 150.0
    }
}



