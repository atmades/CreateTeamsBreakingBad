//
//  MemberCell.swift
//  BreakingBad v2
//
//  Created by Максим on 02/12/2021.
//

import UIKit
import SnapKit
import SDWebImage

protocol MemberCellDelegate: AnyObject {
    func setBoss(index: Int)
    func goToDetail(index: Int)
}

class MemberCell: UITableViewCell {
    
    //    MARK: - Properties
    static let reuseId = "MemberCell"
    private var index = 0
    var delegate: MemberCellDelegate?
    
    //    MARK: - UI Elements
    var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: String.color.gray80.rawValue)
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private var namelabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var chevronRightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "chevronRight")
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private var quotelabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .lightGray
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var weaponslabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(named: String.color.blue.rawValue)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //    MARK: - Gestures
    private func setBossGesture() {
       let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapSetBoss))
        avatarImageView.addGestureRecognizer(gesture)
   }
   @objc private func didTapSetBoss() {
       delegate?.setBoss(index: index)
   }
    private func setGoToDetailGesture() {
       let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapGoToDetail))
        containerView.addGestureRecognizer(gesture)
   }
   @objc private func didTapGoToDetail() {
       delegate?.goToDetail(index: index)
   }
    
    //    MARK: - private func
    
    private func setupWeaponLabelStyle(isEmpty: Bool) {
        if isEmpty {
            weaponslabel.textColor = .lightGray
            weaponslabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        } else {
            weaponslabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            weaponslabel.textColor = UIColor(named: String.color.blue.rawValue)
        }
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-12)
        }
        containerView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(96)
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.bottom.lessThanOrEqualToSuperview().offset(-16)
        }
        containerView.addSubview(namelabel)
        namelabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(16)
            make.top.equalToSuperview().offset(16)
        }
        containerView.addSubview(chevronRightImageView)
        chevronRightImageView.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.left.equalTo(namelabel.snp.right).offset(0)
            make.right.equalToSuperview().offset(-4)
            make.centerY.equalToSuperview()
        }
        containerView.addSubview(quotelabel)
        quotelabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(16)
            make.right.equalTo(chevronRightImageView.snp.left).offset(0)
            make.top.equalTo(namelabel.snp.bottom).offset(16)
//            make.bottom.equalTo(weaponslabel.snp.top).offset(-16)
        }
        containerView.addSubview(weaponslabel)
        weaponslabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(16)
            make.right.equalTo(chevronRightImageView.snp.left).offset(0)
            make.top.equalTo(quotelabel.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    // MARK: - public func
    public func setupCell(name: String, quote: String?, img: String?, weapons: [String]?, index: Int) {
        namelabel.text = name
        self.index = index
        quote == nil ? (quotelabel.text = "No quote") : (quotelabel.text = quote)

        if let imgUrl = img {
            guard let url = URL(string: imgUrl) else { return }
            avatarImageView.sd_setImage(with: url, completed: nil)
        }
        if let weapons = weapons {
            let textWeapon = weapons.joined(separator: ", ")
            weaponslabel.text = textWeapon
            setupWeaponLabelStyle(isEmpty: false)
        } else {
            weaponslabel.text = "No weapons"
            setupWeaponLabelStyle(isEmpty: true)
        }
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        setupLayout()
        setBossGesture()
        setGoToDetailGesture()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
