//
//  NewTeamView.swift
//  BreakingBad v2
//
//  Created by Максим on 01/12/2021.
//

import UIKit

protocol TeamViewDelegate: AnyObject {
    func addMember()
    func nameDidEndEditing(text: String)
    func getAllMembers(members: [MemberUI])
    func getBoss(boss: MemberUI?)
    func didTapMember(member: MemberUI, index: Int, isBoss: Bool)
}

class TeamView: UIView {
    
    //    MARK: - Properties
    weak var delegate: TeamViewDelegate?
    private var errorName = false
    
    private var members = [MemberUI]() {
        didSet {
            delegate?.getAllMembers(members: members)
        }
    }
    private var boss: MemberUI?
    private var nameTeam: String?
    
    //    MARK: - Public Func
    public func checkName(isError: Bool, nameTeam: String?) {
        self.errorName = isError
        self.nameTeam = nameTeam
        let index = IndexPath(row: 1, section: 0)
        tableView.reloadRows(at: [index], with: .automatic)
    }
    public func updateMembers(members: [MemberUI]) {
        self.members = members
        tableView.reloadData()
    }
    public func setNameTeam(nameTeam: String?) {
        guard let nameTeam = nameTeam else { return }
        self.nameTeam = nameTeam
    }
    
    public func setBoss(boss: MemberUI?) {
        self.boss = boss
    }
    
    //    MARK: - UI Elements
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MemberCell.self, forCellReuseIdentifier: MemberCell.reuseId)
        tableView.register(TeamInfoCell.self, forCellReuseIdentifier: TeamInfoCell.reuseId)
        tableView.register(TeamBossCell.self, forCellReuseIdentifier: TeamBossCell.reuseId)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private func createSubviews() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
    
//    MARK: - Init
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

//    MARK: - extension UITableViewDataSource
extension TeamView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count + 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TeamBossCell.reuseId) as? TeamBossCell else { return UITableViewCell() }
            
            cell.updateCell(member: boss)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TeamInfoCell.reuseId) as? TeamInfoCell else { return UITableViewCell() }
            cell.nameIsEmpty(isEmpty: errorName)
            cell.setNameTeam(nameTeam: nameTeam)
            cell.delegate = self
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MemberCell.reuseId) as? MemberCell else { return UITableViewCell() }
            
            cell.delegate = self
            let index = indexPath.row - 2
            let member = members[index]
            cell.setupCell(name: member.name, quote: member.quote, img: member.img, weapons: member.weapons, index: index)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let index = indexPath.row - 2
        
//        If is Boss, delete him and reload boss cell 
        if members[index].name == boss?.name {
            boss = nil
            delegate?.getBoss(boss: boss)
        }
        members.remove(at: index)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }
}

//    MARK: - extension UITableViewDelegate
extension TeamView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row - 2
        let member = members[index]
        let isBoss = member.name == boss?.name ? true : false
        delegate?.didTapMember(member: member, index: index, isBoss: isBoss)
    }
}

//    MARK: - extension TeamTopDelegate
extension TeamView: TeamInfoCellDelegate {
    func didTapAddMember() {
        delegate?.addMember()
    }
    func textFieldDidEndEditing(_ textField: UITextField, text: String) {
        delegate?.nameDidEndEditing(text: text)
    }
}

//    MARK: - extension MemberCellDelegate
extension TeamView: MemberCellDelegate {
    func goToDetail(index: Int) {
        let member = members[index]
        let isBoss = member.name == boss?.name
        delegate?.didTapMember(member: member, index: index, isBoss: isBoss)
    }
    func setBoss(index: Int) {
        let boss = members[index]
        delegate?.getBoss(boss: boss)
        
        self.boss = boss
        let index = IndexPath(row: 0, section: 0)
        tableView.reloadRows(at: [index], with: .automatic)
        tableView.reloadData()
    }  
}
