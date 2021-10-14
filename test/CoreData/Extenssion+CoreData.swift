//
//  Extenssion+CoreData.swift
//  test
//
//  Created by Лиана Чуприна on 06.09.2021.
//

import Foundation
import UIKit
import CoreData

extension NSManagedObjectContext {
    static func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate // swiftlint:disable:this force_cast

        return appDelegate.persistentContainer.viewContext
    }
}
