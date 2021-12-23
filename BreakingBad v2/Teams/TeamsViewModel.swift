//
//  TeamsViewModel.swift
//  BreakingBad v2
//
//  Created by Максим on 30/11/2021.
//

import Foundation

protocol TeamsViewModel {
    var teams: [TeamTemp] { get }
    var teamsNames: Set<String> { get }
    
    func addNewTeam(team: TeamTemp)
    func updateTeam(team: TeamTemp, index: Int, oldNameTeam: String)
    func removeTeam(index: Int)
}

class TeamsViewModelImpl: TeamsViewModel {
    var teamsNames = Set<String>()
    var teams: [TeamTemp] = [TeamTemp]()
    
    func addNewTeam(team: TeamTemp) {
        teams.append(team)
        teamsNames.insert(team.name)
    }
    func updateTeam(team: TeamTemp, index: Int, oldNameTeam: String) {
        teams[index] = team
        teamsNames.remove(oldNameTeam)
        teamsNames.insert(team.name)
    }
    func removeTeam(index: Int) {
        let teamName = teams[index].name
        teams.remove(at: index)
        teamsNames.remove(teamName)
    }
}
