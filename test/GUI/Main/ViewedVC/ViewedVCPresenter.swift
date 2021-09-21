//
//  ViewedVCPresenter.swift
//  test
//
//  Created by Alexandr on 20.09.2021.
//

import Foundation
import Moya

class PresenterViewed {
    private var model = ModelViewed()
    public weak var viewController: ViewedViewController?
    private let providerEmail = MoyaProvider<Articles>()
    
    public func fetchViewedFeed() {
        providerEmail.request(.viewed) { result in
            switch result {
            case .success(let response):
                let articlsResponse = try? response.map(ArticlesResponse.self)
                self.model.articles = articlsResponse?.results ?? []
                self.model.articles.sort {
                    $0.updated.convertToDate()!.compare($1.updated.convertToDate()!) == .orderedDescending
                }
                
                self.viewController?.render(model: self.model)
                
            case .failure(let error):
                print(error.errorCode)
                print(error.errorDescription ?? "Unknown error")
            }
        }
    }
}
