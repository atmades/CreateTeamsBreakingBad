//
//  NewMemberViewController.swift
//  BreakingBad v2
//
//  Created by Максим on 02/12/2021.
//

import UIKit

protocol NewMemberVCDelegate: AnyObject {
    func getMember(member: MemberTemp)
}

class NewMemberViewController: UIViewController {
    
    //    MARK: - Properties
    private let newView = NewMemberView()
    var viewModel: NewMemberViewModel
    weak var delegate: NewMemberVCDelegate?
    
    //    MARK: - NavController
    private func setupNavController() {
        navigationItem.title = "New Member"
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didTapSaveMember))
        navigationItem.rightBarButtonItems = [saveButton]
    }
    @objc
    private func didTapSaveMember() {
        viewModel.checkMember() {(error, result) in
            if let member = result {
                self.delegate?.getMember(member: member)
                self.navigationController?.popViewController(animated: true)
            } else if let error = error {
                self.newView.nameValidation(isError: true, name: self.viewModel.name)
                self.showAlert(error: error)
            }
        }
    }
    
    // MARK: - Init
    init(viewModel: NewMemberViewModel) {
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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: String.color.gray100.rawValue)
        self.disableRightBarButtonsWhenKeyboardIsOpen()
        self.setupTapGestures()
        setupNavController()
        newView.delegate = self
        newView.setWeapons(weapons: viewModel.weapons)
    }
}

//    MARK: - extension NewMemberDelegate
extension NewMemberViewController: NewMemberDelegate {
    func getWeapons(weapons: [String]?) {
        viewModel.setSelectedWeapons(weapons: weapons)
    }
    func quoteDidEndEditing(text: String) {
        viewModel.setQuote(quote: text)
    }
    func nameDidEndEditing(text: String) {
        viewModel.setName(name: text)
    }
    func getRandomData() {  
        viewModel.getRandomData {
            self.newView.setupRandom(name: self.viewModel.name, quote: self.viewModel.quote, imageUrl: self.viewModel.img)
        }
    }
}

//    MARK: - extension MemberSaveAlert
extension NewMemberViewController: MemberSaveAlert { }
