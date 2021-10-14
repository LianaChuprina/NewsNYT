//
//  HomeViewController.swift
//  test
//
//  Created by Alexandr on 16.09.2021.
//

import UIKit
import Moya

final class HomeViewController: BasicTableVC {
    var presenter: PresenterHome?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNameVC(.shared)
        presenter?.homeViewController = self
        showActivityIndicator()
        presenter?.fetchViewedFeed()
    }

    public func render(model: ViewModel) {
        render(model.articles)
        hideActivityIndicator()
        reload()
    }
}
