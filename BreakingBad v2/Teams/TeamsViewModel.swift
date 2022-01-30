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
}

class TeamsViewModelImpl: TeamsViewModel {
    
    var teamsNames = Set<String>()
    var teams: [TeamUI] = [TeamUI]()
    
    var storeAdapter: AdapterStore = AdapterCoreData()
    
    func getTeams() {
        storeAdapter.getTeams() { teams in
            var teamsUI = [TeamUI]()
            for item in teams {
                let teamName = item.teamName
                let members = self.storeAdapter.toMemberUI(members: item.member)
                let membersUI = self.storeAdapter.convertMembersToMembersUI(members: members)
                let boss = self.storeAdapter.getBoss(members: members)
                let bossUI = self.storeAdapter.convertMemberToMemberUI(member: boss)

                if let name = teamName, let members = membersUI, let boss = bossUI {
                    let team = TeamUI(name: name, members: members, boss: boss)
                    teamsUI.append(team)
                }
            }
            self.teams = teamsUI
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
    
    //    MARK: - Init
    init() {
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
