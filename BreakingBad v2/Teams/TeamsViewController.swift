//
//  TeamsViewController.swift
//  BreakingBad v2
//
//  Created by Максим on 30/11/2021.
//

import UIKit

class TeamsViewController: UIViewController {
    
    //    MARK: - Properties
    var viewModel: TeamsViewModel = TeamsViewModelImpl()
    private let newView = TeamsView()
    
    //    MARK: - NavController
    private func setupNavController() {
        navigationItem.title = "Teams"
        let createNewTeam = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(didTapAdd))
        navigationItem.rightBarButtonItems = [createNewTeam]
    }
    @objc
    private func didTapAdd() {
        let viewModelVC = NewTeamViewModelImpl(teamsNames: viewModel.teamsNames)
        let vc = NewTeamViewController(viewModel: viewModelVC)
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //    MARK: - LifeCycle
    override func loadView() {
        view = newView
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar(largeTitleColor: .darkGray,
                                    backgoundColor: .black,
                                    tintColor: UIColor(named: String.color.green.rawValue) ?? .white,
                                    title: "Teams",
                                    preferredLargeTitle: false)
        newView.updateUI(teams: self.viewModel.teams)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupNavController()
        newView.updateUI(teams: viewModel.teams)
        newView.delegate = self
    }
}

//    MARK: - extension NewTeamViewControllerDelegate
extension TeamsViewController: NewTeamViewControllerDelegate {
    func getTeam(team: TeamTemp) {
        viewModel.addNewTeam(team: team)
        newView.updateUI(teams: viewModel.teams)
    }
}

//    MARK: - extension TeamViewControllerDelegate
extension TeamsViewController:  TeamViewControllerDelegate {
    func getTeam(team: TeamTemp, index: Int, oldNameTeam: String) {
        viewModel.updateTeam(team: team, index: index, oldNameTeam: oldNameTeam)
        newView.updateUI(teams: viewModel.teams)
    }
}

//    MARK: - extension TeamsViewDelegate
extension TeamsViewController: TeamsViewDelegate {
    func didTapTeam(team: TeamTemp, index: Int) {
        print("didTapTeam controller")
        let viewModelVC = TeamViewModelImpl(teamsNames: viewModel.teamsNames, team: team, index: index, nameTeam: team.name)
        let vc = TeamViewController(viewModel: viewModelVC)
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

