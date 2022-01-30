//
//  CoreDataStack.swift
//  BreakingBad v2
//
//  Created by Максим on 28/12/2021.
//

import UIKit
import CoreData

protocol CoreDataStackProto {
    var persistentContainer: NSPersistentContainer { get }
    
    func saveContext()
    func deleteAll()
}

class CoreDataStack: CoreDataStackProto {
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BreakingBadModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func deleteAll() {
        lazy var storeContainer = persistentContainer.persistentStoreCoordinator
        for store in storeContainer.persistentStores {
            do {
                try storeContainer.destroyPersistentStore(
                    at: store.url!,
                    ofType: store.type,
                    options: nil
                )
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        // Re-create the persistent container
        persistentContainer = NSPersistentContainer(
            name: "BreakingBadModel" // the name of
            // a .xcdatamodeld file
        )
        // Calling loadPersistentStores will re-create the persistent stores
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
