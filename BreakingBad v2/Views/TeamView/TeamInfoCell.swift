//
//  NewTeamBossCell.swift
//  BreakingBad v2
//
//  Created by Максим on 01/12/2021.
//

import UIKit
import SnapKit

protocol TeamInfoCellDelegate: AnyObject {
    func textFieldDidEndEditing(_ textField: UITextField, text: String)
    func didTapAddMember()
}

class TeamInfoCell: UITableViewCell  {
    
    //    MARK: - Properties
    static let reuseId = "NewTeamBossCell"
    weak var delegate: TeamInfoCellDelegate?
    
//    MARK: - UI Elements
    lazy private var nameTextField: UITextField = {
        let textField = UITextField()
        
        let redPlaceholderText = NSAttributedString(string: "Team Name",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.attributedPlaceholder = redPlaceholderText
        textField.textColor = .white
        textField.backgroundColor = UIColor(named: String.color.gray90.rawValue)
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(named: String.color.gray70.rawValue)?.cgColor
        textField.layer.cornerRadius = 2.0
        textField.setLeftPaddingPoints(10)
        textField.setRightPaddingPoints(10)
        textField.isEnabled = true
        textField.isUserInteractionEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    private var memberslabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "Members"
        label.textColor = UIColor(named: String.color.blue.rawValue)
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy private var addMemberButton: UIButton = {
        let button = MainButton()
        button.backgroundColor = UIColor(named: String.color.green.rawValue)
        button.layer.cornerRadius = 2
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        button.setTitle("Add Member", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapAddMember), for: .touchUpInside)
       
        return button
    }()
    @objc
    private func didTapAddMember() {
        delegate?.didTapAddMember()
    }
    
    // MARK: - private func
    private func setupLayout() {
        contentView.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(24)
            make.height.equalTo(44)
            
        }
        contentView.addSubview(memberslabel)
        memberslabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(nameTextField.snp.bottom).offset(32)
        }
        contentView.addSubview(addMemberButton)
        addMemberButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(memberslabel.snp.bottom).offset(16)
            make.height.equalTo(54)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    // MARK: - public func
    public func nameIsEmpty(isEmpty: Bool) {
        if isEmpty {
            nameTextField.layer.borderColor = UIColor.red.cgColor
        }
     }
    public func setNameTeam(nameTeam: String?) {
        nameTextField.text = nameTeam
    }
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        setupLayout()
        nameTextField.delegate = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - extension UITextFieldDelegate
extension TeamInfoCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        nameTextField.layer.borderColor =  UIColor(named: String.color.gray70.rawValue)?.cgColor
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        delegate?.textFieldDidEndEditing(nameTextField, text: text)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
}
