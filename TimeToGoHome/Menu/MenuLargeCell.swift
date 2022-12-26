//
//  MenuLargeCell.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/12/20.
//

import UIKit

class MenuLargeCell: UITableViewCell {
    
    lazy var itemTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var subUpperTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .useRGB(red: 50, green: 50, blue: 50)
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var subUpperButtonBaseView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    lazy var subUpperButton: UIButton = {
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = .center
//        let attributedTitle: NSAttributedString = NSAttributedString(string: "예정일 변경", attributes: [
//            .foregroundColor:UIColor.black,
//            .font:UIFont.systemFont(ofSize: 15, weight: .bold),
//            .paragraphStyle:paragraphStyle,
//            .underlineStyle:NSUnderlineStyle.single.rawValue,
//            .underlineColor:UIColor.black
//        ])
//
//        let button = UIButton()
//        button.setAttributedTitle(attributedTitle, for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//
//        return button
//    }()
    
    lazy var subUpperButtonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.text = "마지막 근무일 변경"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var subUpperButtonBottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var subUpperButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var subLowerTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .useRGB(red: 50, green: 50, blue: 50)
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 60, green: 60, blue: 67, alpha: 0.29)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setViewFoundation()
        self.initializeObjects()
        self.setSubviews()
        self.setLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

// MARK: - Extension for essential methods
extension MenuLargeCell: EssentialCellHeaderMethods {
    func setViewFoundation() {
        self.contentView.isUserInteractionEnabled = true
        self.selectionStyle = .default
    }
    
    func initializeObjects() {
        
    }
    
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.itemTextLabel,
            self.subUpperTextLabel,
            self.subUpperButtonBaseView,
            self.subLowerTextLabel,
            self.bottomLineView
        ], to: self)
        
        SupportingMethods.shared.addSubviews([
            self.subUpperButtonLabel,
            self.subUpperButtonBottomLineView,
            self.subUpperButton
        ], to: self.subUpperButtonBaseView)
    }
    
    func setLayouts() {
        let safeArea = self.safeAreaLayoutGuide
        
        // itemTextLabel
        NSLayoutConstraint.activate([
            self.itemTextLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 19),
            self.itemTextLabel.heightAnchor.constraint(equalToConstant: 22),
            self.itemTextLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -19),
            self.itemTextLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            //self.itemTextLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -46)
        ])
        
        // subUpperTextLabel
        NSLayoutConstraint.activate([
            self.subUpperTextLabel.bottomAnchor.constraint(equalTo: safeArea.centerYAnchor),
            self.subUpperTextLabel.heightAnchor.constraint(equalToConstant: 25),
            self.subUpperTextLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -31)
        ])
        
        // subUpperButtonBaseView
        NSLayoutConstraint.activate([
            self.subUpperButtonBaseView.bottomAnchor.constraint(equalTo: safeArea.centerYAnchor),
            self.subUpperButtonBaseView.heightAnchor.constraint(equalToConstant: 25),
            self.subUpperButtonBaseView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -31),
            self.subUpperButtonBaseView.widthAnchor.constraint(greaterThanOrEqualToConstant: 10)
        ])
        
        // subUpperButtonLabel
        NSLayoutConstraint.activate([
            self.subUpperButtonLabel.bottomAnchor.constraint(equalTo: self.subUpperButtonBaseView.bottomAnchor),
            self.subUpperButtonLabel.topAnchor.constraint(equalTo: self.subUpperButtonBaseView.topAnchor),
            self.subUpperButtonLabel.leadingAnchor.constraint(equalTo: self.subUpperButtonBaseView.leadingAnchor),
            self.subUpperButtonLabel.trailingAnchor.constraint(equalTo: self.subUpperButtonBaseView.trailingAnchor)
        ])
        
        // subUpperButtonBottomLineView
        NSLayoutConstraint.activate([
            self.subUpperButtonBottomLineView.bottomAnchor.constraint(equalTo: self.subUpperButtonLabel.lastBaselineAnchor),
            self.subUpperButtonBottomLineView.heightAnchor.constraint(equalToConstant: 0.5),
            self.subUpperButtonBottomLineView.leadingAnchor.constraint(equalTo: self.subUpperButtonLabel.leadingAnchor),
            self.subUpperButtonBottomLineView.trailingAnchor.constraint(equalTo: self.subUpperButtonLabel.trailingAnchor)
        ])
        
        // subUpperButton
        NSLayoutConstraint.activate([
            self.subUpperButton.topAnchor.constraint(equalTo: self.subUpperButtonBaseView.topAnchor),
            self.subUpperButton.bottomAnchor.constraint(equalTo: self.subUpperButtonBaseView.bottomAnchor),
            self.subUpperButton.leadingAnchor.constraint(equalTo: self.subUpperButtonBaseView.leadingAnchor),
            self.subUpperButton.trailingAnchor.constraint(equalTo: self.subUpperButtonBaseView.trailingAnchor)
        ])
        
        // subLowerTextLabel
        NSLayoutConstraint.activate([
            self.subLowerTextLabel.topAnchor.constraint(equalTo: safeArea.centerYAnchor),
            self.subLowerTextLabel.heightAnchor.constraint(equalToConstant: 25),
            self.subLowerTextLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -31)
        ])
        
        // bottomLineView
        NSLayoutConstraint.activate([
            self.bottomLineView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.bottomLineView.heightAnchor.constraint(equalToConstant: 0.5),
            self.bottomLineView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.bottomLineView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}

// MARK: - Extension for methods added
extension MenuLargeCell {
    func setCell(_ style: MenuSettingCellType,
                 itemText text: String,
                 subTexts: (upperText: String?, lowerText: String),
                 subUpperButtonTarger: (target: Any?, action: Selector, for: UIControl.Event)? = nil) {
        
        self.itemTextLabel.text = text
        self.subUpperTextLabel.text = subTexts.upperText
        self.subLowerTextLabel.text = subTexts.lowerText
        if let subUpperButtonTarger = subUpperButtonTarger {
            self.subUpperButton.addTarget(subUpperButtonTarger.target, action: subUpperButtonTarger.action, for: subUpperButtonTarger.for)
        }
        
        if case .button(let buttonStyle) = style, case .withSubText = buttonStyle {
            self.subUpperButtonBaseView.isHidden = true
            self.subUpperTextLabel.isHidden = false
        }
        
        if case .button(let buttonStyle) = style, case .withSubButton = buttonStyle {
            self.subUpperButtonBaseView.isHidden = false
            self.subUpperTextLabel.isHidden = true
        }
    }
}
