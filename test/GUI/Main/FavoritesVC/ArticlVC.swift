//
//  ArticlVC.swift
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

class ArticlViewController: UIViewController {
    private var model: ArticlModel?
    
    @IBOutlet private var headLabel: UILabel!
    @IBOutlet private var subLabel: UILabel!
    @IBOutlet private var dataLabel: UILabel!
    @IBOutlet weak var favorDeliteButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headLabel.font = UIFont(name: "Cochin-Bold", size: 20)
        subLabel.font = UIFont(name: "Cochin", size: 16)
        dataLabel.font = UIFont(name: "Cochin", size: 10)
    }
    
    @IBAction func handleFavorite(_ sender: UIButton) {
        saveArticle()
    }
    @IBAction func handleUrl(_ sender: Any) {
        if let url = URL(string: model?.url ?? "") {
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
              let model = model,
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
    
        

        do {
            try context.save()
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

