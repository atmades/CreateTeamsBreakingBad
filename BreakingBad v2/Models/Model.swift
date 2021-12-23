//
//  Model.swift
//  BreakingBad v2
//
//  Created by Максим on 30/11/2021.
//

import Foundation

// MARK: - For API
struct Character: Decodable {
    let id: Int
    let name: String
    let img: String
    let nickname: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "char_id"
        case name
        case img
        case nickname
    }
}
struct Quote: Decodable {
    let quote_id: Int
    let quote: String
}

// MARK: - FOR UI
struct TeamTemp {
    var name: String
    var users: [MemberTemp]
    var boss: MemberTemp
}
struct MemberTemp {
    var name: String
    var img: String?
    var quote: String?
    var weapon: [String]?
}


enum Weapon: String, CaseIterable {
    case nothing = "Barehanded"
    case book = "Book"
    case coocies = "Coocies"
    case ball = "Ball"

    static var weaponsString: [String] {
        return Weapon.allCases.map { $0.rawValue }
    }
}
