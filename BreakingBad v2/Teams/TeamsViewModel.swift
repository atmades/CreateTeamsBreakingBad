//
//  TeamsViewModel.swift
//  BreakingBad v2
//
//  Created by Максим on 30/11/2021.
//

import Foundation

protocol TeamsViewModel {
    var teams: [TeamUI] { get }
    var teamsNames: Set<String> { get }
    
    func getTeams()
    func addNewTeam(team: TeamUI)
    func updateTeam(team: TeamUI, index: Int, oldNameTeam: String)
    func removeTeam(index: Int)
    func deleteTeamByName(index: Int,complition: @escaping()->())
    func deleteAll()
}

class TeamsViewModelImpl: TeamsViewModel {
    
    var teamsNames = Set<String>()
    var teams: [TeamUI] = [TeamUI]()
    
    var storeAdapter: AdapterStore = AdapterCoreData()
    
    func getTeams() {
        storeAdapter.getTeams() { teamsUI in
            print("в viewModel получили \(teamsUI.count)")
            self.teams = teamsUI
            for team in self.teams {
                self.teamsNames.insert(team.name)
            }
        }
    }
 
    func addNewTeam(team: TeamUI) {
        teams.append(team)
        teamsNames.insert(team.name)
        storeAdapter.addTeam(team: team)
    }
    func updateTeam(team: TeamUI, index: Int, oldNameTeam: String) {
        teams[index] = team
        teamsNames.remove(oldNameTeam)
        teamsNames.insert(team.name)
        storeAdapter.updateTeam(oldName: oldNameTeam, teamNew: team)
        self.getTeams()
    }
    func removeTeam(index: Int) {
        let teamName = teams[index].name
        teams.remove(at: index)
        teamsNames.remove(teamName)
    }
    func deleteTeamByName(index: Int, complition: @escaping()->()) {
        print("вошли в deleteTeamByName VIEWMODEL")
        let teamName = teams[index].name
        self.teams.remove(at: index)
        self.teamsNames.remove(teamName)
        storeAdapter.deleteTeamByName(name: teamName) {
            complition()
        }
    }
    func deleteAll() {
        print("вошли в deleteAll VIEWMODEL")
        storeAdapter.deleteAll()
    }
    
    //    MARK: - Init
    init() {
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
