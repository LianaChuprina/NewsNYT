//
//  ViewedVCPresenter.swift
//  test
//
//  Created by Alexandr on 20.09.2021.
//

import Foundation
import Moya

class PresenterViewed {
    private var model = ViewModel()
    public weak var viewController: ViewedViewController?
    private let providerViewed = MoyaProvider<Articles>()
    var alert = UIAlertController()
    
    public func fetchViewedFeed() {
        providerViewed.request(.viewed) { result in
            switch result {
            case .success(let response):
                let articlsResponse = try? response.map(ArticlesResponse.self)
                self.model.articles = articlsResponse?.results ?? []
                self.model.articles.sort {
                    $0.updated.convertToDate()!.compare($1.updated.convertToDate()!) == .orderedDescending
                }
                
                self.viewController?.render(model: self.model)
                
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
