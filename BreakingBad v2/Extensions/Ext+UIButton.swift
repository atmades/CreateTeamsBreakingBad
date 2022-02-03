//
//  Ext+UIButton.swift
//  BreakingBad v2
//
//  Created by Максим on 04/12/2021.
//

import UIKit

class MainButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = self.bounds
        let firstColor = UIColor(named: String.color.yellow.rawValue)?.cgColor ?? UIColor.yellow.cgColor
        let secondColor = UIColor(named: String.color.blue.rawValue)?.cgColor ?? UIColor.yellow.cgColor
        l.colors = [firstColor, secondColor]
        l.startPoint = CGPoint(x: 0, y: 0.5)
        l.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(l, at: 0)
        return l
    }()
}
