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
    var members: [MemberTemp] { get }
    var boss: MemberTemp? { get }
    
    var teamsNames: Set<String> { get }
    var membersNames: Set<String> { get }
    
    //  func
    func setName(name: String)
    func updateMembers(members: [MemberTemp])
    func updateMember(member: MemberTemp, index: Int, oldName: String)
    func setBoss(boss: MemberTemp?)
    func addMember(membber: MemberTemp)
    func setMembersNames(members: [MemberTemp])
    func checkTeam(complition: @escaping(_ error: AlertsName?,_ errorName: Bool, _ result:TeamTemp?) -> ())
}

class NewTeamViewModelImpl: NewTeamViewModel {
    //  properties
    var nameTeam: String?
    var boss: MemberTemp?
    var teamsNames: Set<String>
    var members = [MemberTemp]()
    var membersNames = Set<String>()

    //  func
    func updateMembers(members: [MemberTemp]) {
        self.members = members
    }
    func setName(name: String) {
        self.nameTeam = name
    }
    func setBoss(boss: MemberTemp?) {
        self.boss = boss
    }
    func addMember(membber: MemberTemp) {
        self.members.append(membber)
        self.membersNames.insert(membber.name)
    }
    func setMembersNames(members: [MemberTemp]) {
        members.forEach { membersNames.insert($0.name) }
    }
    func updateMember(member: MemberTemp, index: Int, oldName: String) {
        members[index] = member
        membersNames.remove(oldName)
        membersNames.insert(member.name)
    }
    func checkTeam(complition: @escaping(_ error: AlertsName?,_ errorName: Bool, _ result:TeamTemp?) -> ()) {
        var name: String
        var boss: MemberTemp
        
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
        let team = TeamTemp(name: name, users: members, boss: boss)
        
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

