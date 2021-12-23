//
//  AlertHelper.swift
//  BreakingBad v2
//
//  Created by Максим on 07/12/2021.
//

import UIKit

class AlertHelper {
    typealias Action = () -> ()
    static func showAlert(title: String?, message: String?, over viewController: UIViewController) {
        assert((title ?? message) != nil, "Title OR message must be passed in")

        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(.gotIt)
        viewController.present(ac, animated: true)
    }

    static func showDeleteConfirmation(title: String, message: String?, onConfirm: @escaping Action, over viewController: UIViewController) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            onConfirm()
        }))
        ac.addAction(.cancel)
        viewController.present(ac, animated: true)
    }
}

enum AlertsName {
    case anyError
    
    case teamNameIsExists
    case tameNameIsEmpty
    case teamNameIsIncorrect
    case teamWithoutMembers
    case teamWithoutBoss
    case teamSaved
    
    case memberNameIsExist
    case memberNameIsEmpty
    case memberNameIsIncorrect
}
