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
    var members: [MemberTemp] { get }
    var boss: MemberTemp? { get }
    
    //  heplers
    var teamsNames: Set<String> { get }
    var membersNames: Set<String> { get }
    var index: Int { get }
    
    //  func
    func setNewName(name: String)
    func updateMembers(members: [MemberTemp])
    func setBoss(boss: MemberTemp?)
    func addMember(membber: MemberTemp)
    func updateMember(member: MemberTemp, index: Int, oldName: String)
    func checkTeam(complition: @escaping(_ error: AlertsName?,_ errorName: Bool, _ result:TeamTemp?) -> ())
}

class TeamViewModelImpl: TeamViewModel {
    //  properties
    var oldNameTeam: String
    var currentNameTeam: String?
    var boss: MemberTemp?
    var teamsNames: Set<String>
    var members = [MemberTemp]()
    
    //    heplers
    var membersNames = Set<String>()
    var index: Int
    
    //  func
    func updateMembers(members: [MemberTemp]) {
        self.members = members
    }
    func setNewName(name: String) {
        self.currentNameTeam = name
    }
    
    func setBoss(boss: MemberTemp?) {
        self.boss = boss
    }
    func addMember(membber: MemberTemp) {
        self.members.append(membber)
        self.membersNames.insert(membber.name)
    }
    func setMembersNames(members: [MemberTemp]) {
        members.forEach { member in
            self.membersNames.insert(member.name)
        }
    }
    func updateMember(member: MemberTemp, index: Int, oldName: String) {
        members[index] = member
        membersNames.remove(oldName)
        membersNames.insert(member.name)
    }
    func checkTeam(complition: @escaping(_ error: AlertsName?,_ errorName: Bool, _ result:TeamTemp?) -> ()) {
        var name: String
        var boss: MemberTemp
        
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
        let team = TeamTemp(name: name, users: members, boss: boss)
        complition(nil,false, team)
    }
    
    //    MARK: - Init
    init(teamsNames: Set<String>, team: TeamTemp, index: Int, nameTeam: String) {
        self.teamsNames = teamsNames
        self.members = team.users
        self.currentNameTeam = team.name
        self.boss = team.boss
        self.index = index
        self.oldNameTeam = nameTeam
        setMembersNames(members: team.users)

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
