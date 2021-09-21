//
//  HomeVCPresentor.swift
//  test
//
//  Created by Alexandr on 21.09.2021.
//

import Foundation
import Moya

class PresenterHome {
    private var model = ViewModel()
    public weak var homeViewController: HomeViewController?
    private let providerHome = MoyaProvider<Articles>()
    var alert = UIAlertController()
    
    public func fetchHomeFeed() {
        providerHome.request(.shared) { result in
            switch result {
            case .success(let response):
                let articlsResponse = try? response.map(ArticlesResponse.self)
                self.model.articles = articlsResponse?.results ?? []
                self.model.articles.sort {
                    $0.updated.convertToDate()!.compare($1.updated.convertToDate()!) == .orderedDescending
                }
                self.homeViewController?.render(model: self.model)
                
            case .failure(let error):
                self.alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    print("Yay! You brought your towel!")
                }))
                print(error.errorCode)
                print(error.errorDescription ?? "Unknown error")
            }
        }
    }
}
