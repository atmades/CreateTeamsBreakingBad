//
//  MemberViewModel.swift
//  BreakingBad v2
//
//  Created by Максим on 22/12/2021.
//

import Foundation

protocol MemberViewModel {
    //  properties
    var currentName: String? { get }
    var quote: String? { get }
    var img: String? { get }
    var selectedWeapons: [String]? { get }
    var weapons: [String] { get }
    var membersNames: Set<String> { get }
    
    var oldName: String { get }
    var index: Int { get }
    
    //  func
    func setName(name: String)
    func setQuote(quote: String)
    func setImg(img: String)
    func setSelectedWeapons(weapons: [String]?)
    func setMembersNames(members: [MemberTemp])
    
    func getRandomData(completion: @escaping () -> ())
    func checkMember(complition: @escaping(_ error: AlertsName?, _ result: MemberTemp?) -> ())
}

class MemberViewModelImpl: MemberViewModel {
    
    //  properties
    var currentName: String?
    var quote: String?
    var img: String?
    var weapons = Weapon.weaponsString
    var selectedWeapons: [String]?
    var membersNames = Set<String>()
    var oldName: String
    var index: Int
    
    //  Func
    func setSelectedWeapons(weapons: [String]?) {
        self.selectedWeapons = weapons
    }
    func setName(name: String) {
        self.currentName = name
    }
    func setQuote(quote: String) {
        self.quote = quote
    }
    func setImg(img: String) {
        self.img = img
    }
    func setMembersNames(members: [MemberTemp]) {
        members.forEach { membersNames.insert($0.name) }
    }
    func checkMember(complition: @escaping (AlertsName?, MemberTemp?) -> ()) {
        guard let nameMember = self.currentName, !nameMember.isEmpty else {
            complition(AlertsName.memberNameIsEmpty, nil)
            return
        }
        if nameMember != self.currentName {
            guard !membersNames.contains(nameMember) else {
                complition(AlertsName.memberNameIsExist, nil)
                return
            }
        }
        guard !nameMember.trimmingCharacters(in: .whitespaces).isEmpty else {
            complition(AlertsName.memberNameIsIncorrect, nil)
            return
        }
        let member = MemberTemp(name: nameMember, img: img, quote: quote, weapon: selectedWeapons)
        complition(nil, member)
    }
    func getRandomData(completion: @escaping () -> ()) {
        let networkDataFetcher: NetworkDataFetcher = NetworkDataFetcherImpl()
        
        networkDataFetcher.fetchRandomPhotos(random: Random.characterRandom) { [weak self](randomCharacter) in
            guard let characters = randomCharacter, let self = self else { return }
            let character = characters[0]
            let name = character.name
            let url = character.img
            self.currentName = name
            self.img = url
        }
        networkDataFetcher.fetchRandomQuote(random: Random.quoteRandom) { [weak self](quotesRandom) in
            guard let quotes = quotesRandom, let self = self else { return }
            let quote = quotes[0]
            let textQuote = quote.quote
            self.quote = textQuote
            completion()
        }
    }
    
    //    MARK: - Init
    init(membersNames: Set<String>, member: MemberTemp, index: Int) {
        self.membersNames = membersNames
        self.currentName = member.name
        self.quote = member.quote
        self.img = member.img
        self.selectedWeapons = member.weapon
        self.oldName = member.name
        self.index = index
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

