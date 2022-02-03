//
//  AdaptorCoreData.swift
//  BreakingBad v2
//
//  Created by Максим on 28/01/2022.
//

import Foundation


class AdapterCoreData: AdapterStore {
    
    var storageManager: StorageManager = StorageManagerImpl()
    
    //    MARK: - For Storage
    func getTeams(complition: @escaping([TeamUI])->()) {
        storageManager.getTeams { teams in
            var teamsUI = [TeamUI]()
            print("viewModel got teams \(teams.count)")
            for item in teams {
                let teamName = item.teamName
                let members = self.toMemberUI(members: item.member)
                let membersUI = self.convertMembersToMembersUI(members: members)
                let boss = self.getBoss(members: members)
                let bossUI = self.convertMemberToMemberUI(member: boss)

                if let name = teamName, let members = membersUI, let boss = bossUI {
                    let team = TeamUI(name: name, members: members, boss: boss)
                    teamsUI.append(team)
                }
            }
            print("AdapterCoreData converted teams\(teamsUI.count)")
            complition(teamsUI)
        }
    }
    func addTeam(team: TeamUI) {
        let members = getMembersFromTeamUI(teamNew: team)
        storageManager.addTeam(teamName: team.name, members: members)
    }
    func updateTeam(oldName: String, teamNew: TeamUI) {
        let members = getMembersFromTeamUI(teamNew: teamNew)
        storageManager.updateTeam(oldName: oldName, newMembers: members, newName: teamNew.name)
    }
    
    func deleteTeamByName(name: String, complition: @escaping()->()) {
        storageManager.deleteTeamByName(name: name) {
            complition()
        }
    }
    
    func deleteAll() {
        storageManager.deleteAll()
    }
    
    func getMemberByName(teameName: String, memberName: String, complition: @escaping()->()) {
        storageManager.getMemberByName(teameName: teameName, memberName: memberName) {
            complition()
        }
    }
    //    MARK: - Private func
    private func getMembersFromTeamUI(teamNew: TeamUI) -> [Member] {
        var members = [Member]()
        teamNew.members.forEach {
            convertMemberUItoMember(teamName: teamNew.name,member: $0, isBoss: $0.name == teamNew.boss.name) { member in
                members.append(member)
            }
        }
        return members
    }
    
    private func convertMemberUItoMember(teamName: String, member: MemberUI, isBoss: Bool, compl: @escaping(Member)->()) {
        storageManager.getMember() { newMember in
            newMember.name = member.name
            newMember.quote = member.quote
            newMember.teamName = teamName
            newMember.image = member.img
            newMember.weapons = member.weapons?.joined(separator: ",")
            newMember.isBoss = isBoss
            compl(newMember)
        }
    }
    
    //    MARK: - For UI
    func toMemberUI(members: NSOrderedSet?) -> [Member]? {
//        For convert NSOrderedSet use .array as? YourType
        let members = members?.array as? [Member]
        return members
    }
    func convertMembersToMembersUI(members: [Member]?) -> [MemberUI]? {
        guard let members = members else { return nil }
        var membersUI = [MemberUI]()
        for item in members {
            guard let member = convertMemberToMemberUI(member: item) else { return nil }
            membersUI.append(member)
        }
        guard !membersUI.isEmpty else { return nil }
        return membersUI
    }
    func getBoss(members: [Member]?) -> Member? {
        guard let members = members else { return nil }
        for item in members {
            if item.isBoss{
                return item
            }
        }
        return nil
    }
    func convertMemberToMemberUI(member: Member?) -> MemberUI? {
        guard let memberName = member?.name else { return nil }
        let img = member?.image
        let quote = member?.quote
        let weapons = member?.weapons?.components(separatedBy: ",")
        return  MemberUI(name: memberName, img: img, quote: quote, weapons: weapons)
    }
    
}
