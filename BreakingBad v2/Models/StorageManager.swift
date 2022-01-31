//
//  StorageManager.swift
//  BreakingBad v2
//
//  Created by Максим on 27/01/2022.
//
import CoreData
import UIKit

protocol StorageManager {
    
    func getTeams(complition: @escaping([Team])->())
    func updateTeam(oldName: String, newMembers: [Member], newName: String)
    func addTeam(teamName: String, members: [Member])
    func getMember(complition: @escaping(Member)->())
    func deleteTeamByName(name: String, complition: @escaping()->())
    func deleteAll()
    func getMemberByName(teameName: String, memberName: String, complition: @escaping()->())
}

class StorageManagerImpl: StorageManager {
    
    //    MARK: - Context
    var context: NSManagedObjectContext? {
        let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext
        return context
    }
    
    private func saveContext() {
        guard let context = context else { return }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //    MARK: - add Team
    func addTeam(teamName: String, members: [Member]) {
        guard let context = context else { return }
        let newTeam = Team(context: context)
        newTeam.teamName = teamName
        let newMembers = newTeam.member?.mutableCopy() as? NSMutableOrderedSet
        for item in members {
            newMembers?.add(item)
        }
        newTeam.member = newMembers
        context.insert(newTeam)
        saveContext()
    }

    //    MARK: - Get Teams
    func getTeams(complition: @escaping([Team])->())  {
        guard let context = context else { return }
        let fetchRequest: NSFetchRequest<Team> = Team.fetchRequest()
        do {
            let teams =  try context.fetch(fetchRequest)
//            print("В сторадж тимов всего \(teams.count)")
            complition(teams)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    private func getTeamByName(name: String, complition: @escaping(Team?)->() ) {
        guard let context = context else { return }
        let predicate = NSPredicate(format: "teamName == %@", name)
        let fetchTeam = NSFetchRequest<Team>(entityName: "Team")
        fetchTeam.predicate = predicate
        fetchTeam.returnsObjectsAsFaults = false
        do {
            let teamResults = try context.fetch(fetchTeam)
            complition(teamResults.first)

        } catch {
            print(error)
        }
    }
    
    //    MARK: - update Team
    func updateTeam(oldName: String, newMembers: [Member], newName: String) {
        guard let context = context else { return }
        getTeamByName(name: oldName) { teamOld in
            let newTeam = Team(context: context)
            newTeam.teamName = newName
            let membersTemp = newTeam.member?.mutableCopy() as? NSMutableOrderedSet
            for item in newMembers {
                membersTemp?.add(item)
            }
            newTeam.member = membersTemp
            teamOld?.teamName = newTeam.teamName
            teamOld?.member = newTeam.member
            self.saveContext()
        }
    }
    
    //    MARK: - get Member
    func getMember(complition: @escaping(Member)->()) {
        guard let context = context else { return }
        let newMember = Member(context: context)
        complition(newMember)
    }
    
    func getMemberByName(teameName: String, memberName: String, complition: @escaping()->()) {
        guard let context = context else { return }
        getTeamByName(name: teameName) { team in
            guard let team = team else { return }
            
//           let member = team.member?.array.map() {($0 as? Member)?.name == memberName}
            let members = team.member?.array as? [Member]
            guard let members = members else { return }
            for member in members {
                if member.name == memberName {
                    print("нашли мебмера с именем \(member.name)")
                    context.delete(member)
                    print("удалили и будем сохранять \(member.name)")
                    self.saveContext()
                    complition()
                }
            }
        }
    }
    
    //    MARK: - delete Team
    func deleteTeamByName(name: String, complition: @escaping()->()) {
        guard let context = context else { return }
        getTeamByName(name: name) { team in
            guard let team = team else { return }
            context.delete(team)
            do {
                print("сча будет трай сейв контекст")
                try context.save()
                complition()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteAll() {
        (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.deleteAll()
    }
    
    //    MARK: - delete Team Other Options
//    func deleteTeam(team: Team, complition: @escaping()->()) {
//        context.delete(team as NSManagedObject)
//        do {
//            try context.save()
//            complition()
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
//    }
//
//    func deleteTeamByName(name: String, complition: @escaping()->()) {
//        guard let team = getTeamByName(name) else { return }
//        context.delete(team as NSManagedObject)
//        do {
//            try context.save()
//            complition()
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
//    }
//
//    func deleteTeamByName(name: String) {
//        guard let team = getTeamByName(name) else { return }
//        context.delete(team as NSManagedObject)
//        do {
//            try context.save()
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
//    }
}



//  MARK: - For Future


// ------------- FOR SEARCHING OF MEMBERS -------------
/*
    func getMembers() -> [Member] {
        let fetchRequest: NSFetchRequest<Member> = Member.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            return []
        }
    }
 
    func getMembers(teamName: String) -> [Member]? {
        let predicate = NSPredicate(format: "teamName == %@", teamName)
        let fetchRequest: NSFetchRequest<Member> = Member.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let members = try context.fetch(fetchRequest)
            return members
        } catch {
            return []
        }
    }
 
     func setMemberAsBoss(member: MemberUI) {
         let allMembers = getMembers()
         allMembers.forEach {
             $0.setValue($0.name == member.name, forKey: "isBoss")
         }
     }
 
 */

