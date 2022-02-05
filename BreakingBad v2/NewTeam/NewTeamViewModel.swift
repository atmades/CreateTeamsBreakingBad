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
    var members: [MemberUI] { get }
    var boss: MemberUI? { get }
    
    var teamsNames: Set<String> { get }
    var membersNames: Set<String> { get }
    
    //  func
    func setName(name: String)
    func updateMembers(members: [MemberUI])
    func updateMember(member: MemberUI, index: Int, oldName: String, isBoss: Bool)
    func setBoss(boss: MemberUI?)
    func addMember(membber: MemberUI)
    func setMembersNames(members: [MemberUI])
    func checkTeam(complition: @escaping(_ error: AlertsName?,_ errorName: Bool, _ result:TeamUI?) -> ())
}

class NewTeamViewModelImpl: NewTeamViewModel {
    //  properties
    var nameTeam: String?
    var boss: MemberUI?
    var teamsNames: Set<String>
    var members = [MemberUI]()
    var membersNames = Set<String>()

    //  func
    func updateMembers(members: [MemberUI]) {
        self.members = members
    }
    func setName(name: String) {
        self.nameTeam = name
    }
    func setBoss(boss: MemberUI?) {
        self.boss = boss
    }
    func addMember(membber: MemberUI) {
        self.members.append(membber)
        self.membersNames.insert(membber.name)
    }
    func setMembersNames(members: [MemberUI]) {
        members.forEach { membersNames.insert($0.name) }
    }
    func updateMember(member: MemberUI, index: Int, oldName: String, isBoss: Bool) {
        members[index] = member
        membersNames.remove(oldName)
        membersNames.insert(member.name)
        
        isBoss == true ? setBoss(boss: member) : ()
    }
    func checkTeam(complition: @escaping(_ error: AlertsName?,_ errorName: Bool, _ result:TeamUI?) -> ()) {
        var name: String
        var boss: MemberUI
        
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
        let team = TeamUI(name: name, members: members, boss: boss)
        
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

