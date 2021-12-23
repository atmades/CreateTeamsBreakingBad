//
//  TeamSaveAlert Protocol.swift
//  BreakingBad v2
//
//  Created by Максим on 21/12/2021.
//

import UIKit

protocol TeamSaveAlert {
    func showAlert(error: AlertsName)
}
extension TeamSaveAlert {
    func showAlert(error: AlertsName) {
        switch error {
        case .teamNameIsExists:
            AlertHelper.showAlert(title: "Name exists", message: "A team with the same name already exists in the game", over: self as? UIViewController ?? UIViewController())
        case .tameNameIsEmpty:
            AlertHelper.showAlert(title: "Enter  name", message: "Enter name for team", over: self as? UIViewController ?? UIViewController())
        case .teamNameIsIncorrect:
            AlertHelper.showAlert(title: "Name incorrect", message: "Enter correct name for team", over: self as? UIViewController ?? UIViewController())
        case .teamWithoutMembers:
            AlertHelper.showAlert(title: "Thare are no members", message: "Add members for team", over: self as? UIViewController ?? UIViewController())
        case.teamWithoutBoss:
            AlertHelper.showAlert(title: "Thare is no Boss", message: "Tap on avatar of member for set the boss", over: self as? UIViewController ?? UIViewController())
        default: break
        }
    }
}
