//
//  SettingCell.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/11/17.
//

import UIKit

class SettingCell: UITableViewCell {
    
    lazy var itemTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var openVCImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "openVCImage"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
        
    }()
    
    lazy var switchButton: UISwitch = {
        let switchButton = UISwitch()
        switchButton.isHidden = true
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        
        return switchButton
    }()
    
    lazy var sideLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.isHidden = true
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
extension SettingCell: EssentialCellHeaderMethods {
    func setViewFoundation() {
        self.selectionStyle = .none
        self.contentView.isUserInteractionEnabled = true
    }
    
    func initializeObjects() {
        
    }
    
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.itemTitleLabel,
            self.openVCImageView,
            self.switchButton,
            self.sideLabel,
            self.bottomLineView
        ], to: self)
    }
    
    func setLayouts() {
        let safeArea = self.safeAreaLayoutGuide
        
        // itemTitleLabel
        NSLayoutConstraint.activate([
            self.itemTitleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 11),
            self.itemTitleLabel.heightAnchor.constraint(equalToConstant: 22),
            self.itemTitleLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -11),
            self.itemTitleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16)
        ])
        
        // openVCImageView
        NSLayoutConstraint.activate([
            self.openVCImageView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            self.openVCImageView.heightAnchor.constraint(equalToConstant: 44),
            self.openVCImageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.openVCImageView.widthAnchor.constraint(equalToConstant: 44)
        ])
        
        // switchButton
        NSLayoutConstraint.activate([
            self.switchButton.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            self.switchButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ])
        
        // sideLabel
        NSLayoutConstraint.activate([
            self.sideLabel.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            self.sideLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -31)
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

// MARK: Extension for methods added
extension SettingCell {
    func setCell(_ style: MenuSettingCellType, itemText text: String) {
        self.itemTitleLabel.text = text
        
        switch style {
        case .openVC:
            self.openVCImageView.isHidden = false
            self.switchButton.isHidden = true
            self.sideLabel.isHidden = true
            
        case .switch(let isOn):
            self.openVCImageView.isHidden = true
            self.switchButton.isHidden = false
            self.sideLabel.isHidden = true
            
            self.switchButton.isOn = isOn
            
        case .label(let text):
            self.openVCImageView.isHidden = true
            self.switchButton.isHidden = true
            self.sideLabel.isHidden = false
            
            self.sideLabel.text = text
            
        case .button:
            self.openVCImageView.isHidden = true
            self.switchButton.isHidden = true
            self.sideLabel.isHidden = true
        }
    }
}