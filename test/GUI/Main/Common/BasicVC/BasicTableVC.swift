
import UIKit
import CoreData

class BasicTableVC: BasicViewController {

    private let tableView = UITableView()
    private var articles = [ArticleResponse]()
    private var favoriteArticles = [ArticlesCD]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    public func render(_ articles: [ArticleResponse]) {
        self.articles = articles
    }

    public func reload() {
        tableView.reloadData()
    }
    
    public func fetchArticles() {
        let context = NSManagedObjectContext.getContext()
        let fetchRequest: NSFetchRequest<ArticlesCD> = ArticlesCD.fetchRequest()
        do {
            favoriteArticles = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    private func setupTableView() {

        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self

        addTableFooterView()
        addConstraintsToTableView()
    }

    private func addTableFooterView() { // to remove empty separators

        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
    }

    private func addConstraintsToTableView() {

        tableView.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: tableView,
                                                      attribute: NSLayoutConstraint.Attribute.top,
                                                      relatedBy: NSLayoutConstraint.Relation.equal,
                                                      toItem: view,
                                                      attribute: NSLayoutConstraint.Attribute.top,
                                                      multiplier: 1,
                                                      constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: tableView,
                                                    attribute: NSLayoutConstraint.Attribute.left,
                                                    relatedBy: NSLayoutConstraint.Relation.equal,
                                                    toItem: view,
                                                    attribute: NSLayoutConstraint.Attribute.left,
                                                    multiplier: 1,
                                                    constant: 0)
        let widthConstraint = NSLayoutConstraint(item: tableView,
                                                 attribute: NSLayoutConstraint.Attribute.right,
                                                 relatedBy: NSLayoutConstraint.Relation.equal,
                                                 toItem: view,
                                                 attribute: NSLayoutConstraint.Attribute.right,
                                                 multiplier: 1,
                                                 constant: 0)
        let heightConstraint = NSLayoutConstraint(item: tableView,
                                                  attribute: NSLayoutConstraint.Attribute.bottom,
                                                  relatedBy: NSLayoutConstraint.Relation.equal,
                                                  toItem: view,
                                                  attribute: NSLayoutConstraint.Attribute.bottom,
                                                  multiplier: 1,
                                                  constant: 0)
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
}

extension BasicTableVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    tableView.register(UINib(nibName: "\(ArticlTableViewCell.self)",
                                 bundle: nil), forCellReuseIdentifier: "\(ArticlTableViewCell.self)")

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticlTableViewCell",
        for: indexPath) as? ArticlTableViewCell else { return UITableViewCell() }

        let imageUrl = (articles[indexPath.row].media.count > 0)
            ? articles[indexPath.row].media[0].mediaMetadata[2].url
            : nil
        let model = ArticlModel(
            title: articles[indexPath.row].title,
            time: articles[indexPath.row].updated,
            abstract: nil,
            imageURL: imageUrl,
            idVC: articles[indexPath.row].idVC,
            state: .favorite, url: articles[indexPath.row].url
        )
        
        fetchArticles()
        
//        favoriteArticles.forEach { favoriteArticle in
//            if favoriteArticle.id == model.idVC { model.isFavorite = favoriteArticle.is}
//        }
        
        cell.render(
            with: model
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
                idVC: self.articles[indexPath.row].idVC,
                state: .common,
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

extension BasicTableVC {
    private enum Constants {
        static let cellHeight: CGFloat = 150.0
    }
}
