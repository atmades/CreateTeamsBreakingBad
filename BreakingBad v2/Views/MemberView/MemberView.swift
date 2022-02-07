//
//  NewMemberView.swift
//  BreakingBad v2
//
//  Created by Максим on 02/12/2021.
//

import UIKit

protocol MemberViewDelegate: AnyObject {
    func getRandomData()
    func nameDidEndEditing(text: String)
    func quoteDidEndEditing(text: String)
    func getWeapons(weapons: [String]?)
    func uploadImage()
}

class MemberView: UIView {
    
    weak var delegate: MemberViewDelegate?
    var viewModel: MemberViewViewModel = MemberViewViewModelImpl()
    
    private var name: String?
    private var imageUrl: String?
    private var quote: String = String.placeHolders.quote.rawValue
    private var weapons = [String]()
    private var selectedWeapons = Set<String>()
    private var errorName = false
    
    //    MARK: - UI Elements
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(WeaponCell.self, forCellReuseIdentifier: WeaponCell.reuseId)
        tableView.register(MemberInfoCell.self, forCellReuseIdentifier: MemberInfoCell.reuseId)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = .clear
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
    
    //    MARK: - public func
    func setupUI(name: String?,imageUrl: String?, quote: String?, selectedWeapons: [String]?) {
        viewModel.setupUI(name: name, imageUrl: imageUrl, quote: quote, selectedWeapons: selectedWeapons)
    }
    func setupRandom(name: String?, quote: String?, imageUrl: String? ) {
        viewModel.setupRandom(name: name, quote: quote, imageUrl: imageUrl) {
            let index = IndexPath(row: 0, section: 0)
            self.tableView.reloadRows(at: [index], with: .automatic)
        }
    }
    func nameValidation(isError: Bool, name: String?) {
        viewModel.nameValidation(isError: isError, name: name) {
            let index = IndexPath(row: 0, section: 0)
            self.tableView.reloadRows(at: [index], with: .automatic)
        }
    }
    func setWeapons(weapons: [String]) {
        viewModel.setWeapons(weapons: weapons) {
            self.tableView.reloadData()
        }
    }
    func setAvatar(image: UIImage) {
        ////         Waiting for CoreData
    }
    
    //    MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
        tableView.dataSource = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//    MARK: - extension UITableViewDataSource
extension MemberView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.weapons.count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MemberInfoCell.reuseId) as? MemberInfoCell else { return UITableViewCell() }
            
            cell.delegate = self
            cell.setupNameAndAvatar(name: viewModel.name, imageUrl: viewModel.imageUrl)
            cell.setupQuote(quote: viewModel.quote)
            cell.nameIsEmpty(isEmpty: viewModel.errorName)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WeaponCell.reuseId) as? WeaponCell else { return UITableViewCell() }
            
            let index = indexPath.row - 1
            cell.setupUI(weapon: viewModel.weapons[index], index: index)
            selectedWeapons.contains(viewModel.weapons[index]) ? cell.setupIsSelected(isSelected: true) : cell.setupIsSelected(isSelected: false)
            cell.delegate = self
            return cell
        }
    }
}

//    MARK: - extension NewMemberdelegate
extension MemberView: MemberInfoCellDelegate {
    func didTapUpload() {
        delegate?.uploadImage()
    }
    func quoteDidEndEditing(text: String) {
        delegate?.quoteDidEndEditing(text: text)
    }
    func nameDidEndEditing(_ textField: UITextField, text: String) {
        delegate?.nameDidEndEditing(text: text)
    }
    func getRandomData() {
        delegate?.getRandomData()
    } 
}

//    MARK: - extension WeaponCellDelegate
extension MemberView: WeaponCellDelegate {
    func didTapSelect(selected: Bool, index: Int) {
        
        viewModel.addRemoveWeapon(index: index, isSelected: selected) { isEmpty in
            if isEmpty {
                self.delegate?.getWeapons(weapons: nil)
            } else {
                let selectedArray = Array(self.viewModel.selectedWeapons)
                self.delegate?.getWeapons(weapons: selectedArray)
            }
        }
    }
}
