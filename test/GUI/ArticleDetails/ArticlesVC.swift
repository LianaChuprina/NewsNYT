//
//  ArticlesVC.swift
//  test
//
//  Created by Alexandr on 17.09.2021.
//

import UIKit
import CoreData

enum ArticlContarollerState {
    case favorite
    case delete
}

class ArticlesVC: UIViewController {
    private var model: ArticlModel
    var notification = NotificationCenter.default
    
    @IBOutlet private var headLabel: UILabel!
    @IBOutlet private var subLabel: UILabel!
    @IBOutlet private var dataLabel: UILabel!
    @IBOutlet weak var favorDeliteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Article"
        
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "free-icon-internet-explorer-220355"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(self.handleUrl), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        self.navigationItem.setRightBarButtonItems([item1], animated: true)
        
        switch model.state  {
        case .favorite:
            let btn2 = UIButton(type: .custom)
            btn2.setImage(UIImage(named: "free-icon-star-149221"), for: .normal)
            btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
            btn2.addTarget(self, action: #selector(self.handleFavorite), for: .touchUpInside)
            let item2 = UIBarButtonItem(customView: btn2)
            self.navigationItem.setLeftBarButtonItems([item2], animated: true)
        case .delete:
            navigationItem.leftBarButtonItem = nil
        }
        
        headLabel.text = model.title
        dataLabel.text = model.time
        subLabel.text = model.abstract ?? ""
        headLabel.font = UIFont(name: "Cochin-Bold", size: 20)
        subLabel.font = UIFont(name: "Cochin", size: 16)
        dataLabel.font = UIFont(name: "Cochin", size: 10)
    }
    
    init(model: ArticlModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleFavorite() {
        saveArticle()
    }
    
    @objc func handleUrl() {
        if let url = URL(string: model.url) {
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    public func render(model: ArticlModel) {
        self.model = model
        headLabel.text = model.title
        dataLabel.text = model.time
        subLabel.text = model.abstract ?? ""
        
        switch model.state  {
        case .favorite:
            favorDeliteButton.setTitle("", for: .normal)
        case .delete:
            favorDeliteButton.isHidden = true
        }
    }
    
    private func saveArticle() {
        let context = NSManagedObjectContext.getContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "ArticlesCD", in: context),
              !someEntityExists(
                id: Int64(model.id),
                entityName: "ArticlesCD",
                fieldName: "id",
                context: context
              ) else { return }
        
        let articleObject = ArticlesCD(entity: entity, insertInto: context)
        articleObject.abstract = model.abstract
        articleObject.title = model.title
        articleObject.updatedTime = model.time
        articleObject.id = Int64(model.id)
        articleObject.imageURL = model.imageURL
        articleObject.url = model.url
        
        do {
            try context.save()
            notification.post(name: .newElementCD, object: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func someFunc(cellToRemove: ArticlesCD) {
        let context = NSManagedObjectContext.getContext()
        context.delete(cellToRemove)
        
        do {
            try context.save()
        }
        catch {
            print("Error")
        }
    }
    
    func someEntityExists(id: Int64, entityName: String, fieldName: String, context: NSManagedObjectContext) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "\(fieldName) == %@", String(id))
        
        var results: [NSManagedObject] = []
        
        do {
            results = try context.fetch(fetchRequest)
            print(results)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return results.count > 0
    }
}

struct ArticlModel {
    var title: String
    var time: String
    var abstract: String?
    var imageURL: String?
    var id: Int
    var state: ArticlContarollerState
    var url: String
}
extension Notification.Name {
    static var newElementCD: Notification.Name {
        Notification.Name("newElementCD")
    }
}
