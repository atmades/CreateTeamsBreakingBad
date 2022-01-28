//
//  TeamsView.swift
//  BreakingBad v2
//
//  Created by Максим on 30/11/2021.
//

import UIKit
import SnapKit

protocol TeamsViewDelegate: AnyObject {
    func didTapTeam(team: TeamUI, index: Int)
}

class TeamsView: UIView {
    
    //    MARK: - Properties
    private var teams = [TeamUI]()
    weak var delegate: TeamsViewDelegate?
    
    //    MARK: - UI Elements
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TeamCell.self, forCellReuseIdentifier: TeamCell.reuseId)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = .black
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .light)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 1
        label.text = "There are no teams"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //    MARK: - private func
    private func checkIsEmpty(isEmpty: Bool) {
        if isEmpty {
            tableView.isHidden = true
            emptyLabel.isHidden = false
        } else {
            tableView.isHidden = false
            emptyLabel.isHidden = true
        }
    }
    
    //    MARK: - public func
    public func updateUI(teams: [TeamUI]?) {
        guard let newTeams = teams, !newTeams.isEmpty  else { return checkIsEmpty(isEmpty: true) }
        checkIsEmpty(isEmpty: false)
        self.teams = newTeams
        tableView.reloadData()
    }
    
    //    MARK: - Setup Layout
    private func createSubviews() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
        }
        addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
        }
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
        tableView.dataSource = self
        tableView.delegate = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - extension UITableViewDataSource
extension TeamsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        teams.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TeamCell.reuseId) as? TeamCell else { return UITableViewCell() }
        let team = teams[indexPath.row]
        cell.setupUI(teamName: team.name)
        return cell
    }
}

// MARK: - extension UITableViewDelegate
extension TeamsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tableView didSelectRowAt")
        let team = teams[indexPath.row]
        delegate?.didTapTeam(team: team, index: indexPath.row)
    }
}
