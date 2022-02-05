//
//  Ext+ActivityIndicator.swift
//  BreakingBad v2
//
//  Created by Максим on 02/02/2022.
//

import Foundation
import UIKit

extension UIActivityIndicatorView {
    public func turnOn() {
        isHidden = false
        startAnimating()
    }
    public func turnOff() {
        isHidden = true
        stopAnimating()
    }
}
