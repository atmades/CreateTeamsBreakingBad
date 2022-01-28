//
//  CoreDataStack.swift
//  BreakingBad v2
//
//  Created by Максим on 28/12/2021.
//

import UIKit
import CoreData

protocol CoreDataStackProto {
//    var context: NSManagedObjectContext  { get }
    func saveContext()
    var persistentContainer: NSPersistentContainer { get }
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
    
//    var context: NSManagedObjectContext {
//        return persistentContainer.viewContext
//    }


//    func saveContext() {
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                context.rollback()
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
