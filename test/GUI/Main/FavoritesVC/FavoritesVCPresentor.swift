//
//  FavoritesVCPresentor.swift
//  test
//
//  Created by Alexandr on 21.09.2021.
//

import Foundation
import Moya
import CoreData

class PresenterFavorites {
    var model = ModelFavorites()
    public weak var viewController: FavoritesViewController?
    
    
    public func fetchArticles() {
        let context = NSManagedObjectContext.getContext()
        let fetchRequest: NSFetchRequest<ArticlesCD> = ArticlesCD.fetchRequest()
        do {
            model.articles = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    public func removeCell(cell: ArticlesCD) {
        let context = NSManagedObjectContext.getContext()
        context.delete(cell)
        
        do {
            try context.save()
        }
        catch {
            print("Error")
        }
    }
    
}
