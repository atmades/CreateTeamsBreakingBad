//
//  TeamsViewController.swift
//  BreakingBad v2
//
//  Created by Максим on 30/11/2021.
//

import UIKit

class TeamsViewController: UIViewController {
    
    //    MARK: - Properties
    var viewModel: TeamsViewModel
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
    
    // MARK: - Init
    init(viewModel: TeamsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        viewModel.getTeams()
        newView.updateUI(teams: viewModel.teams)
        newView.delegate = self

    }
}

//    MARK: - extension NewTeamViewControllerDelegate
extension TeamsViewController: NewTeamViewControllerDelegate {
    func getTeam(team: TeamUI) {
        viewModel.addNewTeam(team: team)
    }
}

//    MARK: - extension TeamViewControllerDelegate
extension TeamsViewController:  TeamViewControllerDelegate {
    func getTeam(team: TeamUI, index: Int, oldNameTeam: String) {
        viewModel.updateTeam(team: team, index: index, oldNameTeam: oldNameTeam)
        newView.updateUI(teams: viewModel.teams)
    }
}

//    MARK: - extension TeamsViewDelegate
extension TeamsViewController: TeamsViewDelegate {
    func didTapTeam(team: TeamUI, index: Int) {
        print("didTapTeam controller")
        let viewModelVC = TeamViewModelImpl(teamsNames: viewModel.teamsNames, team: team, index: index, nameTeam: team.name)
        let vc = TeamViewController(viewModel: viewModelVC)
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteTeam(index: Int, indexPath: IndexPath) {
        print("стукнули во viewController")
        viewModel.deleteTeamByName(index: index) {
//            self.newView.deleteRow(index: index, indexPath: indexPath)
            self.newView.updateUI(teams: self.viewModel.teams)
        }
    }
}

