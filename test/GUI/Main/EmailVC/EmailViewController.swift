//
//  EmailViewController.swift
//  test
//
//  Created by Alexandr on 16.09.2021.
//

import UIKit
import Moya

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
