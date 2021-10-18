

import Foundation
import Moya
import CoreData

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var presenter: PresenterFavorites!
    @IBOutlet var tableView: UITableView!
    var notification = NotificationCenter.default
    var ifNeedReload = false

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))

        title = "Favorites"
        notification.addObserver(
            forName: .newElementCD,
            object: nil,
            queue: .main) { _ in

            self.ifNeedReload = true
        }
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "\(ArticlTableViewCell.self)", bundle: nil),
                           forCellReuseIdentifier: "\(ArticlTableViewCell.self)")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.fetchArticles()
        if ifNeedReload {
            tableView.reloadData()
            ifNeedReload = false
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.model.articles.count ?? .zero
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticlTableViewCell",
                                                 for: indexPath)
        if let cellGood = cell as? ArticlTableViewCell {
            cellGood.render(
                with: ArticlModel(
                    title: presenter?.model.articles[indexPath.row].title ?? "",
                    time: presenter?.model.articles[indexPath.row].updatedTime ?? "",
                    abstract: nil,
                    imageURL: presenter?.model.articles[indexPath.row].imageURL,
                    idVC: Int(presenter?.model.articles[indexPath.row].id ?? .zero),
                    state: .favorite,
                    url: presenter?.model.articles[indexPath.row].url ?? ""
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newViewController =  ArticlesVC(
            model: ArticlModel(
                title: presenter?.model.articles[indexPath.row].title ?? "",
                time: presenter?.model.articles[indexPath.row].updatedTime ?? "",
                abstract: presenter?.model.articles[indexPath.row].abstract,
                imageURL: nil,
                idVC: Int(presenter?.model.articles[indexPath.row].id ?? .zero),
                state: .favorite,
                url: presenter?.model.articles[indexPath.row].url ?? ""
            )
        )
        
        newViewController.removeFavoriteNews = { tableView.reloadData() }
        let myNavigationController = UINavigationController(rootViewController: newViewController)
        self.present(myNavigationController, animated: true)
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let action = UIContextualAction(
            style: .destructive,
            title: "Delete") { [weak self] (action,
                                            view,
                                            comletionHandler) in
            guard let self = self else { return }

            guard let article = self.presenter?.model.articles[indexPath.row] else { return }

            self.presenter?.removeArticle(model: article)
            self.presenter?.model.articles.remove(at: indexPath.row)
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
