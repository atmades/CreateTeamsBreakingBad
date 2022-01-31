//
//  TeamCell.swift
//  BreakingBad v2
//
//  Created by Максим on 01/12/2021.
//

import UIKit
import SnapKit
import SDWebImage


class TeamCell: UITableViewCell {
    
    static let reuseId = "TeamCell"
    let imageSize = 48
    
    //    MARK: - UI Elements
    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: String.color.gray80.rawValue)
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var shadow: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        let image = UIImage(named: "shadow")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var allStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private var teamNamelabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(named: String.color.green.rawValue)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var membersCountlabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "12 members"
        label.textColor = UIColor(named: String.color.gray60.rawValue)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var avaStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var avatarImageViewBoss: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        imageView.layer.cornerRadius = 18
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor(named: String.color.green.rawValue)?.cgColor
        imageView.layer.borderWidth = 2
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var avatarImageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        imageView.layer.cornerRadius = 18
        imageView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var avatarImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        imageView.layer.cornerRadius = 18
        imageView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var avatarImageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        imageView.layer.cornerRadius = 18
        imageView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //    MARK: - Private Func
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        containerView.addSubview(allStackView)
        allStackView.addArrangedSubview(titleStackView)
        allStackView.addArrangedSubview(avaStackView)
        allStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.top.greaterThanOrEqualTo(26)
        }
        
        titleStackView.addArrangedSubview(teamNamelabel)
        titleStackView.addArrangedSubview(membersCountlabel)

        avaStackView.addArrangedSubview(avatarImageViewBoss)
        avaStackView.addArrangedSubview(avatarImageView1)
        avaStackView.addArrangedSubview(avatarImageView2)
        avaStackView.addArrangedSubview(avatarImageView3)
        
        avatarImageViewBoss.snp.makeConstraints { make in
            make.width.height.equalTo(36)
        }
        avatarImageView1.snp.makeConstraints { make in
            make.width.height.equalTo(36)
        }
        avatarImageView2.snp.makeConstraints { make in
            make.width.height.equalTo(36)
        }
        avatarImageView3.snp.makeConstraints { make in
            make.width.height.equalTo(36)
        }
        
        containerView.addSubview(shadow)
        shadow.snp.makeConstraints { make in
            make.width.equalTo(78)
            make.height.equalTo(36)
            
            make.right.equalTo(allStackView.snp.right)
            make.top.equalTo(avaStackView.snp.top)
            make.bottom.equalTo(avaStackView.snp.bottom)
        }
    }
    
    // MARK: - public func
    func setupUI(teamName: String){
        teamNamelabel.text = teamName
    }
    
    func setupUI(team: TeamUI) {
        
        //  Set labels texts
        teamNamelabel.text = team.name
        if team.members.count < 2 {
            membersCountlabel.text = "\(team.members.count) member"
        } else {
            membersCountlabel.text = "\(team.members.count) membes"
        }
        
        //  Set boss avatar
        if let imgUrl = team.boss.img {
            guard let url = URL(string: imgUrl) else { return }
            avatarImageViewBoss.sd_setImage(with: url, completed: nil)
        }
        
        //  Set members avatars
        let avatars = [avatarImageView1, avatarImageView2, avatarImageView3]
        var members = [MemberUI]()
        
        team.members.forEach {
            if $0.name != team.boss.name {
                members.append($0)
            }
        }

        for index in (0 ... avatars.count - 1) where index <= members.count-1 {
            if let imgUrl = members[index].img {
                guard let url = URL(string: imgUrl) else { return }
                avatars[index].isHidden = false
                avatars[index].sd_setImage(with: url, completed: nil)
            }
        }
        
        //  Hide the shadow if there are few images
        if avatarImageView2.isHidden == true {
            shadow.isHidden = true
        } else {
            shadow.isHidden = false
        }
    }

    // MARK: - Init and Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        selectionStyle = .none
        setupLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}













/*
class TeamCell: UITableViewCell {
    
    static let reuseId = "TeamCell"
    
    //    MARK: - UI Elements
    var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: String.color.gray80.rawValue)
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var teamNamelabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-12)
        }
        containerView.addSubview(teamNamelabel)
        teamNamelabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(50)
            make.bottom.equalToSuperview().offset(-50)
        }
    }
    
    // MARK: - public func
    func setupUI(teamName: String){
        teamNamelabel.text = teamName
    }

    // MARK: - Init and Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        selectionStyle = .none
        setupLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
*/
