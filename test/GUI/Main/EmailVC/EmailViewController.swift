
import UIKit
import Moya

//hgjjhg,jg

final class EmailViewController: BasicTableVC {
    var presenter: PresenterEmail?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNameVC(.email)
        presenter?.emailViewController = self
        showActivityIndicator()
        presenter?.fetchViewedFeed()
    }

    public func render(model: ViewModel) {
        render(model.articles)
        hideActivityIndicator()
        reload()
    }
}
