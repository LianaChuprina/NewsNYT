

import UIKit
import CoreData

enum ArticlState {
    case favorite
    case common
}

class ArticlesVC: BasicViewController {
    var presenter: ArticleVCPresenter!
    var removeFavoriteNews: (() -> Void)?
    private var model: ArticlModel
    
    @IBOutlet private var headLabel: UILabel!
    @IBOutlet private var subLabel: UILabel!
    @IBOutlet private var dataLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ArticleVCPresenter()
        presenter.viewController = self

        setupNavBarIternet()
        setupNameVC(.article)
        isFavoriteState()
        stateFavoriteOfId()

        setupLabels()
    }

    init(model: ArticlModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func stateFavoriteOfId() {
        model.isFavorite = presenter.fetchArticles(idVC: model.idVC) == nil ? false : true
    }

   public func isFavoriteState() {
       if model.isFavorite {
            setupNavBarHeart(type: .favorite)
            presenter.saveArticle(model: model)

        } else {
            setupNavBarHeart(type: .common)
            presenter.removeArticle(model: model)
        }
    }

    @objc func handleFavorite() {
        model.isFavorite.toggle()
        isFavoriteState()
        removeFavoriteNews?()
    }

    @objc func handleUrl() {
        if let url = URL(string: model.url) {

            if UIApplication.shared.canOpenURL(url) {

                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }

    private func setupLabels() {
        headLabel.text = model.title
        dataLabel.text = model.time
        subLabel.text = model.abstract ?? ""

        headLabel.font = UIFont(name: "Cochin-Bold", size: 20)
        subLabel.font = UIFont(name: "Cochin", size: 16)
        dataLabel.font = UIFont(name: "Cochin", size: 10)
    }

    func setupNavBarHeart(type: ArticlState) {
        let btn2 = UIButton(type: .detailDisclosure)

        switch type {
        case .common:
            btn2.setImage(UIImage(named: "heatt"), for: .normal)
        case .favorite:
            btn2.setImage(UIImage(named: "heart-2"), for: .normal)
        }

        btn2.tintColor = .red
        btn2.image(for: .highlighted)
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
        btn2.addTarget(self, action: #selector(handleFavorite), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: btn2)
        self.navigationItem.setLeftBarButtonItems([item2], animated: true)
    }

    private func setupNavBarIternet() {

        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "free-icon-internet-explorer-220355"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(handleUrl), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        self.navigationItem.setRightBarButtonItems([item1], animated: true)
    }

}

class ArticlModel {
    var title: String
    var time: String
    var abstract: String?
    var imageURL: String?
    var idVC: Int
    var state: ArticlState
    var url: String
    var isFavorite = false
    
    init(title: String, time: String, abstract: String?, imageURL: String?, idVC: Int, state: ArticlState, url: String) {
        self.title = title
        self.time = time
        self.abstract = abstract
        self.imageURL = imageURL
        self.idVC = idVC
        self.state = state
        self.url = url
    }
}

extension Notification.Name {
    static var newElementCD: Notification.Name {
        Notification.Name("newElementCD")
    }
}
