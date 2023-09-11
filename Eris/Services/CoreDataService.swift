//
//  DI.swift
//  Eris
//
//  Created by Dmitry Chicherin on 12/9/2566 BE.
//

import Foundation
import CoreData

final class CoreDataService {
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
