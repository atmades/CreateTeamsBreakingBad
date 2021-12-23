//
//  TeamCell.swift
//  BreakingBad v2
//
//  Created by Максим on 01/12/2021.
//

import UIKit
import SnapKit

class TeamCell: UITableViewCell {
    
    static let reuseId = "TeamCell"
    
    //    MARK: - UI Elements
    var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: String.color.gray80.rawValue)
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var teamNamelabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-12)
        }
        containerView.addSubview(teamNamelabel)
        teamNamelabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(50)
            make.bottom.equalToSuperview().offset(-50)
        }
    }
    // MARK: - public func
    func setupUI(teamName: String){
        teamNamelabel.text = teamName
    }

    // MARK: - Init and Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        setupLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
