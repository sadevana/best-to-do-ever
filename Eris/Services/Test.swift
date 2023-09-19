//
//  Test.swift
//  Eris
//
//  Created by Dmitry Chicherin on 19/9/2566 BE.
//

import Foundation
import CoreData

final class CoreDataService2 {
    static let shared = CoreDataService()
    
    private let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
        return container
    }()

    func context() -> NSManagedObjectContext {
        return container.viewContext
    }

}
