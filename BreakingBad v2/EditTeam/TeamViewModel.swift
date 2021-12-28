//
//  TeamViewModel.swift
//  BreakingBad v2
//
//  Created by Максим on 22/12/2021.
//

import Foundation

protocol TeamViewModel {
    //  properties
    var oldNameTeam: String { get }
    var currentNameTeam: String? { get }
    var members: [Member] { get }
    var boss: Member? { get }
    
    //  heplers
    var teamsNames: Set<String> { get }
    var membersNames: Set<String> { get }
    var index: Int { get }
    
    //  func
    func setNewName(name: String)
    func updateMembers(members: [Member])
    func setBoss(boss: Member?)
    func addMember(membber: Member)
    func updateMember(member: Member, index: Int, oldName: String)
    func checkTeam(complition: @escaping(_ error: AlertsName?,_ errorName: Bool, _ result:Team?) -> ())
}

class TeamViewModelImpl: TeamViewModel {
    //  properties
    var oldNameTeam: String
    var currentNameTeam: String?
    var boss: Member?
    var teamsNames: Set<String>
    var members = [Member]()
    
    //    heplers
    var membersNames = Set<String>()
    var index: Int
    
    //  func
    func updateMembers(members: [Member]) {
        self.members = members
    }
    func setNewName(name: String) {
        self.currentNameTeam = name
    }
    
    func setBoss(boss: Member?) {
        self.boss = boss
    }
    func addMember(membber: Member) {
        self.members.append(membber)
        self.membersNames.insert(membber.name)
    }
    func setMembersNames(members: [Member]) {
        members.forEach { member in
            self.membersNames.insert(member.name)
        }
    }
    func updateMember(member: Member, index: Int, oldName: String) {
        members[index] = member
        membersNames.remove(oldName)
        membersNames.insert(member.name)
    }
    func checkTeam(complition: @escaping(_ error: AlertsName?,_ errorName: Bool, _ result:Team?) -> ()) {
        var name: String
        var boss: Member
        
        //  Check Name
        guard let nameTeam = self.currentNameTeam, !nameTeam.isEmpty else {
            complition(AlertsName.tameNameIsEmpty, true, nil)
            return
        }
        guard !nameTeam.trimmingCharacters(in: .whitespaces).isEmpty else {
            complition(AlertsName.teamNameIsIncorrect,true, nil)
            return
        }
        if nameTeam != oldNameTeam {
            guard !teamsNames.contains(nameTeam) else {
                complition(AlertsName.teamNameIsExists, false, nil)
                return }
        }
        
        //  Check Members
        guard !members.isEmpty else {
            complition(AlertsName.teamWithoutMembers, false, nil)
            return
        }
        
        //  Check Boss
        guard let bossTeam = self.boss else {
            complition(AlertsName.teamWithoutBoss, false, nil)
            return
        }
        name = nameTeam
        boss = bossTeam
        let team = Team(name: name, members: members, boss: boss)
        complition(nil,false, team)
    }
    
    //    MARK: - Init
    init(teamsNames: Set<String>, team: Team, index: Int, nameTeam: String) {
        self.teamsNames = teamsNames
        self.members = team.members
        self.currentNameTeam = team.name
        self.boss = team.boss
        self.index = index
        self.oldNameTeam = nameTeam
        setMembersNames(members: team.members)

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
