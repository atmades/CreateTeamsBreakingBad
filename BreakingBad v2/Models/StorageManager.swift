//
//  StorageManager.swift
//  BreakingBad v2
//
//  Created by Максим on 27/01/2022.
//
import CoreData

protocol StorageManager {
    
    func saveContext()
    func addTeam(team: TeamUI)
    func addMember(teamName: String, member: MemberUI, isBoss: Bool) -> Member
    func getTeams() -> [Team]
    func getMembers() -> [Member]
    func getTeamByName(_ name: String) -> Team?
    func getTeams(complition: @escaping([Team])->())
    func getMembers(teamName: String) -> [Member]?
    func updateTeam(name: String, teamNew: TeamUI)
}

class StorageManagerImpl: StorageManager {
    
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BreakingBadModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func addTeam(team: TeamUI) {
        let newTeam = Team(context: context)
        newTeam.teamName = team.name
        var members = [Member]()
        team.members.forEach {
            let member = addMember(teamName: team.name, member: $0, isBoss: $0.name == team.boss.name)
            members.append(member)
        }
        let newMembers = newTeam.member?.mutableCopy() as? NSMutableOrderedSet
        for item in members {
            newMembers?.add(item)
        }
        newTeam.member = newMembers
        context.insert(newTeam)
        saveContext()
    }
    
    func addMember(teamName: String, member: MemberUI, isBoss: Bool) -> Member {
        let newMember = Member(context: context)
        newMember.name = member.name
        newMember.quote = member.quote
        newMember.teamName = teamName
        newMember.image = member.img
        newMember.weapons = member.weapons?.joined(separator: ",")
        newMember.isBoss = isBoss
        
        return newMember
    }
    
//    func setMemberAsBoss(member: MemberUI) {
//        let allMembers = getMembers()
//        allMembers.forEach {
//            $0.setValue($0.name == member.name, forKey: "isBoss")
//        }
//    }
    
    func saveContext() {
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
    
    func getTeams() -> [Team] {
        let fetchRequest: NSFetchRequest<Team> = Team.fetchRequest()
        do {
            let teams =  try context.fetch(fetchRequest)
            print("В сторадж тимов всего \(teams.count)")
            
            return teams
        } catch {
            return []
        }
    }
    
    func getTeams(complition: @escaping([Team])->())  {
        let fetchRequest: NSFetchRequest<Team> = Team.fetchRequest()
        do {
            let teams =  try context.fetch(fetchRequest)
            print("В сторадж тимов всего \(teams.count)")
            
            complition(teams)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    
    
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
    
    func getTeamByName(_ name: String) -> Team? {
        let predicate = NSPredicate(format: "teamName == %@", name)
          let fetchTeam = NSFetchRequest<Team>(entityName: "Team")
          fetchTeam.predicate = predicate
          fetchTeam.returnsObjectsAsFaults = false
        do {
          if let teamResults = try context.fetch(fetchTeam) as? [Team] {
              return teamResults.first
          }
        } catch {
          print(error)
        }
        return nil
    }
    
    func getTeamByName(name: String, complition: @escaping(Team?)->() ) {
        let predicate = NSPredicate(format: "teamName == %@", name)
          let fetchTeam = NSFetchRequest<Team>(entityName: "Team")
          fetchTeam.predicate = predicate
          fetchTeam.returnsObjectsAsFaults = false
        do {
          if let teamResults = try context.fetch(fetchTeam) as? [Team] {
              complition(teamResults.first)
          }
        } catch {
          print(error)
        }
    }
    
    func updateTeam(name: String, teamNew: TeamUI) {
//        let team = Team(context: context)
//        team.name = newTeam.name
//        do {
//            context.setValue(newTeam, forKey: name)
//            try context.save()
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
        
        
        getTeamByName(name: name) { teamOld in
            let newTeam = Team(context: self.context)
            newTeam.teamName = teamNew.name
            var members = [Member]()
            teamNew.members.forEach {
                let member = self.addMember(teamName: teamNew.name, member: $0, isBoss: $0.name == teamNew.boss.name)
                members.append(member)
            }
            let newMembers = newTeam.member?.mutableCopy() as? NSMutableOrderedSet
            for item in members {
                newMembers?.add(item)
            }
            newTeam.member = newMembers
            teamOld?.teamName = newTeam.teamName
            teamOld?.member = newTeam.member
            self.saveContext()
        }
    }
    
    func deleteTeam(team: Team, complition: @escaping()->()) {
        context.delete(team as NSManagedObject)
        do {
            try context.save()
            complition()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func deleteTeamByName(name: String, complition: @escaping()->()) {
        guard let team = getTeamByName(name) else { return }
        context.delete(team as NSManagedObject)
        do {
            try context.save()
            complition()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    func deleteTeamByName(name: String) {
        guard let team = getTeamByName(name) else { return }
        context.delete(team as NSManagedObject)
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
