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
        print("начинаем крутить")
        isHidden = false
        startAnimating()
    }
    public func turnOff() {
        print("заканчиваем крутить")
        isHidden = true
        stopAnimating()
    }
}
