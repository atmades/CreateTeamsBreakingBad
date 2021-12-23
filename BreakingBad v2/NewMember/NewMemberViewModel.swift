//
//  NewMemberViewModel.swift
//  BreakingBad v2
//
//  Created by Максим on 04/12/2021.
//

import Foundation

protocol NewMemberViewModel {
    var name: String? { get }
    var quote: String? { get }
    var img: String? { get }
    var selectedWeapons: [String]? { get }
    var weapons: [String] { get }
    var membersNames: Set<String> { get }
    
    //  func
    func setName(name: String)
    func setQuote(quote: String)
    func setImg(img: String)
    func setSelectedWeapons(weapons: [String]?)
    func setMembersNames(members: [MemberTemp])
    
    func getRandomData(completion: @escaping () -> ())
    func checkMember(complition: @escaping(_ error: AlertsName?, _ result:MemberTemp?) -> ())
}

class NewMemberViewModelImpl: NewMemberViewModel {
    var name: String?
    var quote: String?
    var img: String?
    var weapons = Weapon.weaponsString
    var selectedWeapons: [String]?
    var membersNames = Set<String>()
    
    //  func
    func setSelectedWeapons(weapons: [String]?) {
        self.selectedWeapons = weapons
    }
    func setName(name: String) {
        self.name = name
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
        guard let nameMember = self.name, !nameMember.isEmpty else {
            complition(AlertsName.memberNameIsEmpty, nil)
            return
        }
        guard !membersNames.contains(nameMember) else {
            complition(AlertsName.memberNameIsExist, nil)
            return
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
            self.name = name
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
    init(membersNames: Set<String>) {
        self.membersNames = membersNames
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


