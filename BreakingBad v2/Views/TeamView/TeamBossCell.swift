//
//  TeamBossCell.swift
//  BreakingBad v2
//
//  Created by Максим on 08/12/2021.
//

import UIKit
import SDWebImage

class TeamBossCell: UITableViewCell {
    
    //    MARK: - properties
    static let reuseId = "TeamBossCell"
    
    //    MARK: - Ui Elements
    private var bossPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(named: String.color.gray70.rawValue)
        imageView.layer.cornerRadius = 75
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private var bosslabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .lightGray
        label.text = "The Boss"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var bossNamelabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //    MARK: - private func
    private func setupLayout() {
        contentView.addSubview(bossPhotoImageView)
        bossPhotoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(150)
            make.centerX.equalTo(self)
            make.top.equalToSuperview().offset(24)
        }
        contentView.addSubview(bosslabel)
        bosslabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(bossPhotoImageView.snp.bottom).offset(16)
        }
        contentView.addSubview(bossNamelabel)
        bossNamelabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(bosslabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    //    MARK: - public func
    public func updateCell(member: MemberUI?) {
        guard let boss = member
        else {
            bossNamelabel.text = "There is no boss"
            bossNamelabel.textColor = .lightGray
            return
        }
        bossNamelabel.text = boss.name
        bossNamelabel.textColor = .white
        if let imgUrl = boss.img {
            guard let url = URL(string: imgUrl) else { return }
            bossPhotoImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    //    MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        setupLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
