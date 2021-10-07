//
//  ViewedViewController.swift
//  test
//
//  Created by Alexandr on 16.09.2021.
//

import UIKit
import Moya

final class ViewedViewController: BasicTableVC {
    var presenter: PresenterViewed?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNameVC(.viewed)
        presenter?.viewController = self
        showActivityIndicator()
        presenter?.fetchViewedFeed()
    }
    
    public func render(model: ViewModel) {
        render(model.articles)
        hideActivityIndicator()
        reload()
    }
}

