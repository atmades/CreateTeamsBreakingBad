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
struct TeamUI {
    var name: String
    var members: [MemberUI]
    var boss: MemberUI
}
struct MemberUI {
    var name: String
    var img: String?
    var quote: String?
    var weapons: [String]?
}

enum WeaponsBase: String, CaseIterable {
    case nothing = "Barehanded"
    case book = "Book"
    case coocies = "Coocies"
    case ball = "Ball"

    static var weaponsString: [String] {
        return WeaponsBase.allCases.map { $0.rawValue }
    }
}
