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
    private var timer: Timer?
    
    private var filteredTeams = [TeamUI]()
    private var searching = false
    
    //    MARK: - SearchController
    private var searсhController: UISearchController = {
        let searсhController = UISearchController(searchResultsController: nil)
        searсhController.searchBar.barStyle = .black
        searсhController.searchBar.searchBarStyle = .default
        return searсhController
    } ()
    
    //    MARK: - NavController
    private func setupNavController() {
        navigationItem.title = "Teams"
        navigationItem.searchController = searсhController
        navigationItem.hidesSearchBarWhenScrolling = false
        let addImage = UIImage(named: String.icons.add.rawValue)
        let addButton = UIBarButtonItem(image: addImage, style: .plain, target: self, action: #selector(didTapAdd))
        navigationItem.rightBarButtonItems = [addButton]
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
        searching ? newView.updateUI(teams: self.filteredTeams) : newView.updateUI(teams: self.viewModel.teams)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupNavController()
        
        viewModel.getTeams()
        newView.updateUI(teams: viewModel.teams)
        newView.delegate = self
        searсhController.searchBar.delegate = self
        filteredTeams = viewModel.teams
        
        self.configureNavigationBar(largeTitleColor: .darkGray,
                                    backgoundColor: .black,
                                    tintColor: UIColor(named: String.color.green.rawValue) ?? .white,
                                    title: "Teams",
                                    preferredLargeTitle: false)
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
        let viewModelVC = TeamViewModelImpl(teamsNames: viewModel.teamsNames, team: team, index: index, nameTeam: team.name)
        let vc = TeamViewController(viewModel: viewModelVC)
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteTeam(index: Int, indexPath: IndexPath) {
        viewModel.deleteTeamByName(index: index) {
            self.newView.updateUI(teams: self.viewModel.teams)
        }
    }
}

//    MARK: - Extension UISearchBardelegate
extension TeamsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            
            self.filteredTeams = self.viewModel.teams.filter {
                $0.name.lowercased().prefix(searchText.count) == searchText.lowercased()
            }
            self.searching = true
            self.newView.updateUI(teams: self.filteredTeams)
        })
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        newView.updateUI(teams: viewModel.teams)
    }
}

