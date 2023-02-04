//
//  MenuCell.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/11/16.
//

import UIKit

enum MenuCellType {
    case normal
    case sideLabel(String)
    case button(MenuButtonType)
}

enum MenuButtonType {
    case withoutAnything
    case withSubText
    case withSubButton
}

class MenuCell: UITableViewCell {
    lazy var menuIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var itemTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var sideLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
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
extension MenuCell: EssentialCellHeaderMethods {
    func setViewFoundation() {
        //self.selectionStyle = .none
        self.contentView.isUserInteractionEnabled = true
    }
    
    func initializeObjects() {
        
    }
    
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.menuIconImageView,
            self.itemTextLabel,
            self.sideLabel,
        ], to: self)
    }
    
    func setLayouts() {
        let safeArea = self.safeAreaLayoutGuide
        
        // menuIconImageView
        NSLayoutConstraint.activate([
            self.menuIconImageView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            self.menuIconImageView.heightAnchor.constraint(equalTo: safeArea.heightAnchor),
            self.menuIconImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            self.menuIconImageView.widthAnchor.constraint(equalToConstant: 19)
        ])
        
        // itemTextLabel
        NSLayoutConstraint.activate([
            self.itemTextLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 13),
            self.itemTextLabel.heightAnchor.constraint(equalToConstant: 24),
            self.itemTextLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -13),
            self.itemTextLabel.leadingAnchor.constraint(equalTo: self.menuIconImageView.trailingAnchor, constant: 16),
            self.itemTextLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -46)
        ])
        
        // sideLabel
        NSLayoutConstraint.activate([
            self.sideLabel.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            self.sideLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -32)
        ])
    }
}

// MARK: Extension for methods added
extension MenuCell {
    func setCell(_ style: MenuCellType, iconName: String, itemText text: String, isEnable: Bool = true) {
        self.selectionStyle = isEnable ? .default : .none
        
        self.menuIconImageView.image = UIImage(named: iconName)
        self.itemTextLabel.text = text
        
        self.menuIconImageView.alpha = isEnable ? 1.0 : 0.5
        self.itemTextLabel.alpha = isEnable ? 1.0 : 0.5
        
        switch style {
        case .normal:
            self.itemTextLabel.font = .systemFont(ofSize: 20, weight: .bold)
            
            self.sideLabel.isHidden = true
            
        case .sideLabel(let text):
            self.itemTextLabel.font = .systemFont(ofSize: 20, weight: .regular)
            self.sideLabel.text = text
            
            self.sideLabel.isHidden = false
            self.selectionStyle = .none // for joiningDate and side label element would be just label.
            
        case .button:
            self.itemTextLabel.font = .systemFont(ofSize: 20, weight: .bold)
            
            self.sideLabel.isHidden = true
        }
    }
}
