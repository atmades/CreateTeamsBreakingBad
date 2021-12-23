//
//  Ext+UIAlert.swift
//  BreakingBad v2
//
//  Created by Максим on 07/12/2021.
//

import UIKit

extension UIAlertAction {
    static var gotIt: UIAlertAction {
        return UIAlertAction(title: "Ok", style: .default, handler: nil)
    }
    static var cancel: UIAlertAction {
        return UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    }
}
