//
//  ArticleVCPresentor.swift
//  test
//
//  Created by Alexandr on 22.09.2021.
//

import Foundation
import Moya
import CoreData

class ArticleVCPresenter {

    var viewController: ArticlesVC!

    let notification = NotificationCenter.default

    public func saveArticle(model: ArticlModel) {

        let context = NSManagedObjectContext.getContext()

        guard let entity = NSEntityDescription.entity(forEntityName: "ArticlesCD", in: context),
              !someEntityExists(
                idVC: Int64(model.idVC),
                entityName: "ArticlesCD",
                fieldName: "id",
                context: context
              ) else { return }

        let articleObject = ArticlesCD(entity: entity, insertInto: context)
        articleObject.abstract = model.abstract
        articleObject.title = model.title
        articleObject.updatedTime = model.time
        articleObject.id = Int64(model.idVC)
        articleObject.imageURL = model.imageURL
        articleObject.url = model.url

        do {
            try context.save()
            notification.post(name: .newElementCD, object: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func someEntityExists(idVC: Int64,
                          entityName: String,
                          fieldName: String,
                          context: NSManagedObjectContext) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "\(fieldName) == %@", String(idVC))

        var results: [NSManagedObject] = []

        do {
            results = try context.fetch(fetchRequest)
            print(results) } catch {
            print("error executing fetch request: \(error)")
        }
        return results.count > 0
    }

    public func fetchArticles(idVC: Int) -> ArticlesCD? {

        let context = NSManagedObjectContext.getContext()
        let fetchRequest: NSFetchRequest<ArticlesCD> = ArticlesCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", String(idVC))
        var results: [NSManagedObject] = []

        do {
            results = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return results.first as? ArticlesCD
    }

    public func removeArticle(model: ArticlModel) {

        let context = NSManagedObjectContext.getContext()

        guard let entity = fetchArticles(idVC: model.idVC) else { return }

        context.delete(entity)
        do {
            try context.save()} catch {
            print("Error")
        }
    }
}
