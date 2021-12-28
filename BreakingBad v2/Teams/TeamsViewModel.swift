//
//  TeamsViewModel.swift
//  BreakingBad v2
//
//  Created by Максим on 30/11/2021.
//

import Foundation

protocol TeamsViewModel {
    var game: Game? { get }
    var gameName: String { get }
    var teams: [Team] { get }
    var teamsNames: Set<String> { get }
    
    func getGame(name: String)
    
    func addNewTeam(team: Team)
    func updateTeam(team: Team, index: Int, oldNameTeam: String)
    func removeTeam(index: Int)
}

class TeamsViewModelImpl: TeamsViewModel {
    var game: Game?
    var gameName: String
    var teamsNames = Set<String>()
    var teams: [Team] = [Team]()
    
//    Data Core Part
    
    func getGame(name: String) {
        
    }
    
    
    
    
    
    
    
    func addNewTeam(team: Team) {
        teams.append(team)
        teamsNames.insert(team.name)
    }
    func updateTeam(team: Team, index: Int, oldNameTeam: String) {
        teams[index] = team
        teamsNames.remove(oldNameTeam)
        teamsNames.insert(team.name)
    }
    func removeTeam(index: Int) {
        let teamName = teams[index].name
        teams.remove(at: index)
        teamsNames.remove(teamName)
    }
    
    //    MARK: - Init
    init(gameName: String) {
        self.gameName = gameName
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
