//
//  WeaponCell.swift
//  BreakingBad v2
//
//  Created by Максим on 02/12/2021.
//

import UIKit
import SnapKit

protocol WeaponCellDelegate: AnyObject {
    func didTapSelect(selected: Bool, index: Int)
}

class WeaponCell: UITableViewCell {
    
    //    MARK: - Properties
    static let reuseId = "WeaponCell"
    private var isSelectedButton = false
    private var index = 0
    
    weak var delegate: WeaponCellDelegate?
    
    //  MARK: - UI Elements
    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: String.color.gray80.rawValue)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var weaponlabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var selecthButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.cornerRadius = 16
        let icon = UIImage(named: "selectedOff")
        button.setImage(icon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //    MARK: - Private Func
    private func setupTapGestures() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss))
        containerView.addGestureRecognizer(gesture)
    }
    @objc
    private func handleTapDismiss() {
        if isSelectedButton {
            setupSelectedStyle(isSelected: false)
            isSelectedButton = false
            delegate?.didTapSelect(selected: isSelectedButton, index: index)
        } else {
            setupSelectedStyle(isSelected: true)
            isSelectedButton = true
            delegate?.didTapSelect(selected: isSelectedButton, index: index)
        }
   }
    private func setupSelectedStyle(isSelected: Bool) {
        if isSelected {
            let image = UIImage(named: "selectedOn")
            selecthButton.setImage(image, for: .normal)
        } else {
            let image = UIImage(named: "selectedOff")
            selecthButton.setImage(image, for: .normal)
        }
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(0)
        }
        containerView.addSubview(weaponlabel)
        weaponlabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        containerView.addSubview(selecthButton)
        selecthButton.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.left.equalTo(weaponlabel.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalTo(self)
        }
    }
    
    //    MARK: - public Func
    func setupUI(weapon: String, index: Int) {
        weaponlabel.text = weapon
        self.index = index
    }
    func setupIsSelected(isSelected: Bool) {
        self.isSelectedButton = isSelected
        setupSelectedStyle(isSelected: isSelected)
    }
    
    //    MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        contentView.backgroundColor = .black
        setupTapGestures()
        setupLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
