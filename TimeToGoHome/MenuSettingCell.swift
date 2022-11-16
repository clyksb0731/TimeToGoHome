//
//  MenuSettingCell.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/11/16.
//

import UIKit

enum MenuSettingCellType {
    case openVC
    case `switch`(Bool)
    case label(String)
    case button
}

class MenuSettingCell: UITableViewCell {
    
    lazy var menuTextLabel: UILabel = {
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
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        
        return switchButton
    }()
    
    lazy var sideLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .bold)
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
extension MenuSettingCell: EssentialCellHeaderMethods {
    func setViewFoundation() {
        self.selectionStyle = .none
        self.contentView.isUserInteractionEnabled = true
    }
    
    func initializeObjects() {
        
    }
    
    func setSubviews() {
        
    }
    
    func setLayouts() {
        
    }
}

// MARK: Extension for methods added
extension MenuSettingCell {
    func setCell(_ style: MenuSettingCellType, menuText text: String) {
        self.menuTextLabel.text = text
        
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
