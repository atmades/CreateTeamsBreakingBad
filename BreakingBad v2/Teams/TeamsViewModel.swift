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
    
    //    Data Core Part
    var storageManager: StorageManager = StorageManagerImpl()
    
    func getTeams() {
        let teams = storageManager.getTeams()
        var teamsUI = [TeamUI]()
        for item in teams {
            let teamName = item.teamName
            let members = toMemberUI(members: item.member)
            let membersUI = convertMembersToMembersUI(members: members)
            let boss = getBoss(members: members)
            let bossUI = convertMemberToMemberUI(member: boss)

            if let name = teamName, let members = membersUI, let boss = bossUI {
                let team = TeamUI(name: name, members: members, boss: boss)
                teamsUI.append(team)
            }
        }
        self.teams = teamsUI

    }
 
    func addNewTeam(team: TeamUI) {
        teams.append(team)
        teamsNames.insert(team.name)
        
        storageManager.addTeam(team: team)
    }
    func updateTeam(team: TeamUI, index: Int, oldNameTeam: String) {
        teams[index] = team
        teamsNames.remove(oldNameTeam)
        teamsNames.insert(team.name)
        storageManager.updateTeam(name: oldNameTeam, teamNew: team)
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

//    MARK: - Adapter Model
extension TeamsViewModelImpl {
    private func toMemberUI(members: NSOrderedSet?) -> [Member]? {
//        For convert NSOrderedSet use .array as? YourType
        let members = members?.array as? [Member]
        return members
    }
    private func convertMembersToMembersUI(members: [Member]?) -> [MemberUI]? {
        guard let members = members else { return nil }
        var membersUI = [MemberUI]()
        for item in members {
            guard let member = convertMemberToMemberUI(member: item) else { return nil }
            membersUI.append(member)
        }
        guard !membersUI.isEmpty else { return nil }
        return membersUI
    }
    private func getBoss(members: [Member]?) -> Member? {
        guard let members = members else { return nil }
        for item in members {
            if item.isBoss{
                return item
            }
        }
        return nil
    }
    private func convertMemberToMemberUI(member: Member?) -> MemberUI? {
        guard let memberName = member?.name else { return nil }
        let img = member?.image
        let quote = member?.quote
        let weapons = member?.weapons?.components(separatedBy: ",")
        return  MemberUI(name: memberName, img: img, quote: quote, weapons: weapons)
    }
    
    private func convertTeamUItoTeam(teamUI: TeamUI) {
        
    }
}
