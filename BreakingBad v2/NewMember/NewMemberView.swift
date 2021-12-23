//
//  NewMemberView.swift
//  BreakingBad v2
//
//  Created by Максим on 02/12/2021.
//

import UIKit

protocol NewMemberDelegate: AnyObject {
    func getRandomData()
    func nameDidEndEditing(text: String)
    func quoteDidEndEditing(text: String)
    func getWeapons(weapons: [String]?)
}

class NewMemberView: UIView {
    
    weak var delegate: NewMemberDelegate?
    
    private var name: String?
    private var imageUrl: String?
    private var quote: String = String.placeHolders.quote.rawValue
    private var weapons = [String]()
    private var selectedWeapons = [String]()
    private var errorName = false
    
    //    MARK: - UI Elements
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(WeaponCell.self, forCellReuseIdentifier: WeaponCell.reuseId)
        tableView.register(NewMemberCell.self, forCellReuseIdentifier: NewMemberCell.reuseId)
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
    public func setupNameAndAvatar(name: String?,imageUrl: String?) {
        self.name = name
        self.imageUrl = imageUrl
        let index = IndexPath(row: 0, section: 0)
        tableView.reloadRows(at: [index], with: .automatic)
    }
    
    public func setupQuote(quote: String?) {
        guard let quote = quote else { return }
        self.quote = quote
        let index = IndexPath(row: 0, section: 0)
        tableView.reloadRows(at: [index], with: .automatic)
    }
    
    public func setupRandom(name: String?, quote: String?, imageUrl: String? ) {
        self.name = name
        self.imageUrl = imageUrl
        if let quote = quote {
            self.quote = quote
        }
        let index = IndexPath(row: 0, section: 0)
        tableView.reloadRows(at: [index], with: .automatic)
    }
    
    public func nameValidation(isError: Bool, name: String?) {
        self.errorName = isError
        self.name = name
        let index = IndexPath(row: 0, section: 0)
        tableView.reloadRows(at: [index], with: .automatic)
    }
    
    public func setWeapons(weapons: [String]) {
        self.weapons = weapons
        tableView.reloadData()
    }
    
    public func setSelectedWeapons(weapons: [String]?) {
        guard let selectedWeapons = weapons else { return }
        self.selectedWeapons = selectedWeapons
        tableView.reloadData()
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
extension NewMemberView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weapons.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewMemberCell.reuseId) as? NewMemberCell else { return UITableViewCell() }
            
            cell.delegate = self
            cell.setupNameAndAvatar(name: name, imageUrl: imageUrl)
            cell.setupQuote(quote: quote)
            cell.nameIsEmpty(isEmpty: errorName)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WeaponCell.reuseId) as? WeaponCell else { return UITableViewCell() }
            
            let index = indexPath.row - 1
            cell.setupUI(weapon: weapons[index], index: index)
            selectedWeapons.contains(weapons[index]) ? cell.setupIsSelected(isSelected: true) : cell.setupIsSelected(isSelected: false)
            cell.delegate = self
            return cell
        }
    }
}

//    MARK: - extension NewMemberdelegate
extension NewMemberView: NewMemberdelegate {
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
extension NewMemberView: WeaponCellDelegate {
    func didTapSelect(selected: Bool, index: Int) {
        let weapon = weapons[index]
        
        //  add/remove selected weapon
        if selected {
            selectedWeapons.append(weapon)
            
        } else {
            selectedWeapons.remove(at: index)
        }
        
        if selectedWeapons.isEmpty {
            delegate?.getWeapons(weapons: nil)
        } else {
            delegate?.getWeapons(weapons: selectedWeapons)
        }
    }
}
