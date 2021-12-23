//
//  MemberSaveAlertProtocol.swift
//  BreakingBad v2
//
//  Created by Максим on 23/12/2021.
//

import UIKit

protocol MemberSaveAlert {
    func showAlert(error: AlertsName)
}
extension MemberSaveAlert {
    func showAlert(error: AlertsName) {
        switch error {
        case .memberNameIsEmpty:
            AlertHelper.showAlert(title: "Enter name", message: "Enter a name for the member", over: self as? UIViewController ?? UIViewController())
        case .memberNameIsExist:
            AlertHelper.showAlert(title: "Name exists", message: "A member with the same name already exists in the team", over: self as? UIViewController ?? UIViewController())
        case .memberNameIsIncorrect:
            AlertHelper.showAlert(title: "Name incorrect", message: "Enter correct name for the member", over: self as? UIViewController ?? UIViewController())
        default: break
        }
    }
}
