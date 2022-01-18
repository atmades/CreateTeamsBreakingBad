//
//  DataService.swift
//  BreakingBad v2
//
//  Created by Максим on 28/12/2021.
//

import UIKit
import CoreData

class DataService {
    
    static var context: NSManagedObjectContext? {
        let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext
        return context
    }
    
    //    Create Game for Name or Set existed
    func getGameForName(gameName: String, complition: @escaping(Game)->()) {
        guard let context = DataService.context else { return }
        let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", gameName)
        do {
            
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                let newGame = Game(context: context)
                print("Новая игра")
                print(newGame.name)
                try context.save()
                complition(newGame)
            }
            else {
                let game = results.first
                guard let game = game else { return }
                print("Существующая игра")
                print(game.name)
                complition(game)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
}
