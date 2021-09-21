//
//  EmailVCPresentor.swift
//  test
//
//  Created by Alexandr on 21.09.2021.
//

import Foundation
import Moya

class PresenterEmail {
    private var model = ViewModel()
    public weak var emailViewController: EmailViewController?
    private let providerEmail = MoyaProvider<Articles>()
    
    public func fetchEmailFeed() {
        providerEmail.request(.emailed) { result in
            switch result {
            case .success(let response):
                let articlsResponse = try? response.map(ArticlesResponse.self)
                self.model.articles = articlsResponse?.results ?? []
                self.model.articles.sort {
                    $0.updated.convertToDate()!.compare($1.updated.convertToDate()!) == .orderedDescending
                }
                self.emailViewController?.render(model: self.model)
                
            case .failure(let error):
                print(error.errorCode)
                print(error.errorDescription ?? "Unknown error")
            }
        }
    }
}
