//
//  NewTeamViewModel.swift
//  BreakingBad v2
//
//  Created by Максим on 08/12/2021.
//

import Foundation

protocol NewTeamViewModel {
    //  properties
    var nameTeam: String? { get }
    var members: [Member] { get }
    var boss: Member? { get }
    
    var teamsNames: Set<String> { get }
    var membersNames: Set<String> { get }
    
    //  func
    func setName(name: String)
    func updateMembers(members: [Member])
    func updateMember(member: Member, index: Int, oldName: String)
    func setBoss(boss: Member?)
    func addMember(membber: Member)
    func setMembersNames(members: [Member])
    func checkTeam(complition: @escaping(_ error: AlertsName?,_ errorName: Bool, _ result:Team?) -> ())
}

class NewTeamViewModelImpl: NewTeamViewModel {
    //  properties
    var nameTeam: String?
    var boss: Member?
    var teamsNames: Set<String>
    var members = [Member]()
    var membersNames = Set<String>()

    //  func
    func updateMembers(members: [Member]) {
        self.members = members
    }
    func setName(name: String) {
        self.nameTeam = name
    }
    func setBoss(boss: Member?) {
        self.boss = boss
    }
    func addMember(membber: Member) {
        self.members.append(membber)
        self.membersNames.insert(membber.name)
    }
    func setMembersNames(members: [Member]) {
        members.forEach { membersNames.insert($0.name) }
    }
    func updateMember(member: Member, index: Int, oldName: String) {
        members[index] = member
        membersNames.remove(oldName)
        membersNames.insert(member.name)
    }
    func checkTeam(complition: @escaping(_ error: AlertsName?,_ errorName: Bool, _ result:Team?) -> ()) {
        var name: String
        var boss: Member
        
        guard let nameTeam = self.nameTeam, !nameTeam.isEmpty else {
            complition(AlertsName.tameNameIsEmpty, true, nil)
            return
        }
        guard !nameTeam.trimmingCharacters(in: .whitespaces).isEmpty else {
            complition(AlertsName.teamNameIsIncorrect,true, nil)
            return
        }
        guard !teamsNames.contains(nameTeam) else {
            complition(AlertsName.teamNameIsExists, false, nil)
            return }
        
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
    init(teamsNames: Set<String>) {
        self.teamsNames = teamsNames
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

