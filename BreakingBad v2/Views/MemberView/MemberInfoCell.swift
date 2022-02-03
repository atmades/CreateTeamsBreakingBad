//
//  NewMemberCell.swift
//  BreakingBad v2
//
//  Created by Максим on 02/12/2021.
//

import UIKit
import SnapKit
import SDWebImage

protocol MemberInfoCellDelegate: AnyObject {
    func getRandomData()
    func nameDidEndEditing(_ textField: UITextField, text: String)
    func quoteDidEndEditing(text: String)
    func didTapUpload()
}

class MemberInfoCell: UITableViewCell {
    //    MARK: - Properties
    static let reuseId = "NewMemberCell"
    weak var delegate: MemberInfoCellDelegate?
    var quoteText = ""
    
//    MARK: - UI Elements
    private var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(named: String.color.gray70.rawValue)
        imageView.layer.cornerRadius = 95
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.style = .large
        indicator.translatesAutoresizingMaskIntoConstraints = false
//        indicator.turnOff()
        return indicator
    }()
    private var uploadButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: String.color.gray90.rawValue)
        button.layer.cornerRadius = 6
        let color = UIColor(named: String.color.green.rawValue)
        button.setTitleColor(color, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.setTitle("Upload image", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapUpload), for: .touchUpInside)
        return button
    }()
    @objc
    private func didTapUpload() {
        
        delegate?.didTapUpload()
    }
    lazy private var nameTextField: UITextField = {
        let textField = UITextField()
        let redPlaceholderText = NSAttributedString(string: "Member Name",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.attributedPlaceholder = redPlaceholderText
        textField.textColor = .white
        textField.backgroundColor = UIColor(named: String.color.gray90.rawValue)
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(named: String.color.gray70.rawValue)?.cgColor
        textField.layer.cornerRadius = 2.0
        textField.setLeftPaddingPoints(10)
        textField.setRightPaddingPoints(10)
        textField.isEnabled = true
        textField.isUserInteractionEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    lazy private var quoteTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(named: String.color.gray90.rawValue)
        textView.textAlignment = .center
        textView.textColor = .lightGray
        textView.layer.cornerRadius = 2
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor(named: String.color.gray70.rawValue)?.cgColor
        textView.isEditable = true
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    private var orLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "or"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy private var setRandomButton: UIButton = {
        let button = MainButton()
        button.layer.cornerRadius = 2
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        button.setTitle("Set random", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapRandom), for: .touchUpInside)
        return button
    }()
    @objc
    private func didTapRandom() {
        setRandomButton.setTitle("Wait please ...", for: .normal)
        activityIndicator.turnOn()
        delegate?.getRandomData()
    }
    
    //    MARK: - Private Func
    private var chooseStafflabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "Choose Staff"
        label.textColor = UIColor(named: String.color.blue.rawValue)
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private func setupLayout() {
        contentView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(190)
            make.centerX.equalTo(self)
            make.top.equalToSuperview().offset(16)
        }
        contentView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.centerY.equalTo(avatarImageView)
            make.centerX.equalTo(avatarImageView)
        }
        contentView.addSubview(uploadButton)
        uploadButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(130)
            make.centerX.equalTo(self)
            make.top.equalTo(avatarImageView.snp.bottom).offset(16)
        }
        contentView.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(uploadButton.snp.bottom).offset(24)
            make.height.equalTo(44)
        }
        contentView.addSubview(quoteTextView)
        quoteTextView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(nameTextField.snp.bottom).offset(24)
            make.height.equalTo(120)
        }
        contentView.addSubview(orLabel)
        orLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(quoteTextView.snp.bottom).offset(16)
        }
        contentView.addSubview(setRandomButton)
        setRandomButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(orLabel.snp.bottom).offset(16)
            make.height.equalTo(54)
        }
        contentView.addSubview(chooseStafflabel)
        chooseStafflabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(setRandomButton.snp.bottom).offset(32)
            make.bottom.equalToSuperview().offset(-24)
        }
    }
    
    //    MARK: - Public Func
    public func setupNameAndAvatar(name: String?, imageUrl: String?){
        setRandomButton.setTitle("Set random", for: .normal)
        
        self.nameTextField.text = name
        guard let imageUrl = imageUrl else { return }
        guard let url = URL(string: imageUrl) else { return }
        avatarImageView.sd_setImage(with: url, completed: nil)
        activityIndicator.turnOff()
    }
    public func setupQuote(quote: String){
        if quote == String.placeHolders.quote.rawValue {
            quoteTextView.textColor = .lightGray
        } else {
            quoteTextView.textColor = .white
        }
        self.quoteTextView.text = quote
    }
   public func nameIsEmpty(isEmpty: Bool) {
       if isEmpty {
           nameTextField.layer.borderColor = UIColor.red.cgColor
       }
    }
    
    //    MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .black
        setupLayout()
        nameTextField.delegate = self
        quoteTextView.delegate = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - extension UITextFieldDelegate
extension MemberInfoCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        nameTextField.layer.borderColor =  UIColor(named: String.color.gray70.rawValue)?.cgColor
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        delegate?.nameDidEndEditing(nameTextField, text: text)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
}

//    MARK: - extension UITextViewDelegate
extension MemberInfoCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.layer.borderColor = UIColor(named: String.color.gray70.rawValue)?.cgColor
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .white
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        quoteText = textView.text
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = String.placeHolders.quote.rawValue
            textView.textColor = UIColor.lightGray
            quoteText = ""
        } else {
            quoteText = textView.text
            delegate?.quoteDidEndEditing(text: quoteText)
        }
    }
}
