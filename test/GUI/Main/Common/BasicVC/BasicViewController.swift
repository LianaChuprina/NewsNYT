

import UIKit

enum StateNameVC {
    case viewed
    case email
    case shared
    case article
}

class BasicViewController: UIViewController {

    var activityView: UIActivityIndicatorView?

    public func setupNameVC(_ state: StateNameVC) {
        switch state {
        case .email:
            title = "Email"
        case .viewed:
            title = "Viewed"
        case .shared:
            title = "Shared"
        case .article:
            title = "Article"
        }
    }

    public func showActivityIndicator() {

        activityView = UIActivityIndicatorView(style: .large)
        activityView?.center = self.view.center
        activityView?.hidesWhenStopped = true
        self.view.addSubview(activityView!)
        activityView?.startAnimating()
    }

    public func hideActivityIndicator() {
        if activityView != nil {
            activityView?.stopAnimating()
        }
    }

    public func showAlert(_ alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
}
