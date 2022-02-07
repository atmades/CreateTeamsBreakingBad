//
//  MemberViewViewModel.swift
//  BreakingBad v2
//
//  Created by Максим on 05/02/2022.
//

import Foundation

protocol MemberViewViewModel {
    var name: String? { get }
    var imageUrl: String? { get }
    var quote: String { get }
    var weapons: [String] { get }
    var selectedWeapons: Set<String> { get }
    var errorName: Bool { get }
    
    func setupUI(name: String?,imageUrl: String?, quote: String?, selectedWeapons: [String]?)
    func setupRandom(name: String?, quote: String?, imageUrl: String?, complition: @escaping()->())
    func nameValidation(isError: Bool, name: String?, complition: @escaping()->())
    func setWeapons(weapons: [String], complition: @escaping()->())
    func addRemoveWeapon(index: Int, isSelected: Bool,  complition: @escaping(Bool)->()) 
}

class MemberViewViewModelImpl: MemberViewViewModel {
    var name: String?
    var imageUrl: String?
    var quote: String = String.placeHolders.quote.rawValue
    var weapons: [String] = [String]()
    var selectedWeapons: Set<String> = Set<String>()
    var errorName: Bool = false
    
    func setupUI(name: String?,imageUrl: String?, quote: String?, selectedWeapons: [String]?) {
        self.name = name
        self.imageUrl = imageUrl
        if let quote = quote {
            self.quote = quote
        }
        if let selectedWeapons = selectedWeapons {
            self.selectedWeapons = Set(selectedWeapons)
        }
    }
    
    func setupRandom(name: String?, quote: String?, imageUrl: String?, complition: @escaping()->()) {
        self.name = name
        self.imageUrl = imageUrl
        if let quote = quote {
            self.quote = quote
        }
        complition()
    }
    func nameValidation(isError: Bool, name: String?, complition: @escaping()->()) {
        self.errorName = isError
        self.name = name
        complition()
    }
    func setWeapons(weapons: [String], complition: @escaping()->()) {
        self.weapons = weapons
        complition()
    }
    func addRemoveWeapon(index: Int, isSelected: Bool,  complition: @escaping(Bool)->()) {
        let weapon = weapons[index]
        if isSelected {
            selectedWeapons.insert(weapon)
        } else {
            selectedWeapons.remove(weapon)
        }
        //  Check isEmpty and delegate
        complition(selectedWeapons.isEmpty )
//        if selectedWeapons.isEmpty {
////            delegate?.getWeapons(weapons: nil)
//        } else {
//            let selectedArray = Array(selectedWeapons)
////            delegate?.getWeapons(weapons: selectedArray)
//        }
    }
}
