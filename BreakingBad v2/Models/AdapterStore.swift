//
//  AdapterStore.swift
//  BreakingBad v2
//
//  Created by Максим on 28/01/2022.
//

import Foundation

protocol AdapterStore {
    func getTeams(complition: @escaping([Team])->())
    func updateTeam(oldName: String, teamNew: TeamUI)
    func addTeam(team: TeamUI)
    func deleteTeamByName(name: String, complition: @escaping()->())
    
    func toMemberUI(members: NSOrderedSet?) -> [Member]?
    func getBoss(members: [Member]?) -> Member?
    func convertMembersToMembersUI(members: [Member]?) -> [MemberUI]?
    func convertMemberToMemberUI(member: Member?) -> MemberUI?
    func deleteAll()
}
