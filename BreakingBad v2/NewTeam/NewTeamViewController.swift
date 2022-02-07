//
//  NewTeamViewController.swift
//  BreakingBad v2
//
//  Created by Максим on 01/12/2021.
//

import UIKit

protocol NewTeamViewControllerDelegate: AnyObject {
    func getTeam(team: TeamUI)
}

class NewTeamViewController: UIViewController {
    
    //    MARK: - Properties
    private let newView = TeamView()
    var viewModel: NewTeamViewModel
    weak var delegate: NewTeamViewControllerDelegate?
    
    //    MARK: - NavController
    private func setupNavController() {
        navigationItem.title = "New Team"
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didTapSaveTeam))
        navigationItem.rightBarButtonItems = [saveButton]
    }
    @objc
    private func didTapSaveTeam() {
        viewModel.checkTeam() { (error, isError, result) in
            if let team = result {
                self.delegate?.getTeam(team: team)
                self.navigationController?.popViewController(animated: true)
            } else if let error = error {
                self.showAlert(error: error)
                self.newView.checkName(isError: isError, nameTeam: self.viewModel.nameTeam)
            }
        }
    }
    
    // MARK: - Init
    init(viewModel: NewTeamViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - LifeCicle
    override func loadView() {
        view = newView
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        newView.updateMembers(members: viewModel.members)
        newView.setNameTeam(nameTeam: viewModel.nameTeam)
        newView.setBoss(boss: viewModel.boss)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTapGestures()
        self.disableRightBarButtonsWhenKeyboardIsOpen()
        setupNavController()
        newView.delegate = self
    }
}

//    MARK: - extension NewTeamDelegate
extension NewTeamViewController: TeamViewDelegate {
    func didTapMember(member: MemberUI, index: Int, isBoss: Bool) {
        let viewModelVC = MemberViewModelImpl(membersNames: viewModel.membersNames, member: member, index: index, isBoss: isBoss)
        let vc = MemberViewController(viewModel: viewModelVC)
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func getBoss(boss: MemberUI?) {
        viewModel.setBoss(boss: boss)
    }
    func getAllMembers(members: [MemberUI]) {
        viewModel.updateMembers(members: members)
    }
    func nameDidEndEditing(text: String) {
        viewModel.setName(name: text)
    }
    func addMember() {
        let viewModelVC = NewMemberViewModelImpl(membersNames: viewModel.membersNames)
        let vc = NewMemberViewController(viewModel: viewModelVC)
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//    MARK: - extension NewMemberVCDelegate
extension NewTeamViewController: NewMemberVCDelegate {
    func getMember(member: MemberUI) {
        viewModel.addMember(membber: member)
    }
}

//    MARK: - extension MemberVCDelegate
extension NewTeamViewController: MemberVCDelegate {
    func getMember(member: MemberUI, oldName: String, index: Int, isBoss: Bool) {
        viewModel.updateMember(member: member, index: index, oldName: oldName, isBoss: isBoss)
        newView.updateMembers(members: viewModel.members)
    }
}

//    MARK: - extension TeamSaveAlert
extension NewTeamViewController: TeamSaveAlert { }
