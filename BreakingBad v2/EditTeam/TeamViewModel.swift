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
    var members: [MemberUI] { get }
    var boss: MemberUI? { get }
    
    //  heplers
    var teamsNames: Set<String> { get }
    var membersNames: Set<String> { get }
    var index: Int { get }
    
    //  func
    func setNewName(name: String)
    func updateMembers(members: [MemberUI])
    func setBoss(boss: MemberUI?)
    func addMember(membber: MemberUI)
    func updateMember(member: MemberUI, index: Int, oldName: String, isBoss: Bool)
    func checkTeam(complition: @escaping(_ error: AlertsName?,_ errorName: Bool, _ result:TeamUI?) -> ())
}

class TeamViewModelImpl: TeamViewModel {
    //  properties
    var oldNameTeam: String
    var currentNameTeam: String?
    var boss: MemberUI?
    var teamsNames: Set<String>
    var members = [MemberUI]()
    
    //    heplers
    var membersNames = Set<String>()
    var index: Int
    
    //  func
    func updateMembers(members: [MemberUI]) {
        self.members = members
    }
    func setNewName(name: String) {
        self.currentNameTeam = name
    }
    
    func setBoss(boss: MemberUI?) {
        self.boss = boss
    }
    func addMember(membber: MemberUI) {
        self.members.append(membber)
        self.membersNames.insert(membber.name)
    }
    func setMembersNames(members: [MemberUI]) {
        members.forEach { member in
            self.membersNames.insert(member.name)
        }
    }
    func updateMember(member: MemberUI, index: Int, oldName: String, isBoss: Bool) {
        members[index] = member
        membersNames.remove(oldName)
        membersNames.insert(member.name)
        
        isBoss == true ? setBoss(boss: member) : ()
        print(isBoss)
    }
    func checkTeam(complition: @escaping(_ error: AlertsName?,_ errorName: Bool, _ result:TeamUI?) -> ()) {
        var name: String
        var boss: MemberUI
        
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
        let team = TeamUI(name: name, members: members, boss: boss)
        complition(nil,false, team)
    }
    
    //    MARK: - Init
    init(teamsNames: Set<String>, team: TeamUI, index: Int, nameTeam: String) {
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
