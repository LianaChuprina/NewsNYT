

import Foundation
import Moya

class PresenterEmail {
    private var model = ViewModel()
    public weak var emailViewController: EmailViewController?
    private let providerEmail = MoyaProvider<Articles>()
    let alert = UIAlertController(title: "Error", message: "", preferredStyle: UIAlertController.Style.alert)
    public func fetchViewedFeed() {
        providerEmail.request(.emailed) { result in
            switch result {
            case .success(let response):
                print(response.statusCode)
                switch response.statusCode {
                case 200:
                    let articlsResponse = try? response.map(ArticlesResponse.self)
                    self.model.articles = articlsResponse?.results ?? []
                    self.model.articles.sort {
                        $0.updated.convertToDate()!.compare($1.updated.convertToDate()!) == .orderedDescending
                    }

                    self.emailViewController?.render(model: self.model)

                default:
                    self.alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                        print("Error")
                    }))

                    self.emailViewController?.showAlert(self.alert)
                }

            case .failure(let error):
                self.alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                    print("Error")
                }))

                self.emailViewController?.showAlert(self.alert)
                print(error.errorCode)
                print(error.errorDescription ?? "Unknown error")
            }
        }
    }
}
