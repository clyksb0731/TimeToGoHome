//
//  SettingCompanyAddressCell.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2023/01/08.
//

import UIKit

class SettingCompanyAddressCell: UITableViewCell {
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var bottomLine: UIView = {
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
extension SettingCompanyAddressCell: EssentialCellHeaderMethods {
    func setViewFoundation() {
        self.selectionStyle = .none
        self.contentView.isUserInteractionEnabled = true
    }
    
    func initializeObjects() {
        
    }
    
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.addressLabel,
            self.bottomLine
        ], to: self)
    }
    
    func setLayouts() {
        let safeArea = self.safeAreaLayoutGuide
        
        // addressLabel
        NSLayoutConstraint.activate([
            self.addressLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 11),
            self.addressLabel.heightAnchor.constraint(equalToConstant: 22),
            self.addressLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.addressLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // bottomLine
        NSLayoutConstraint.activate([
            self.bottomLine.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.bottomLine.heightAnchor.constraint(equalToConstant: 0.5),
            self.bottomLine.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.bottomLine.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}

// MARK: - Extension for methods added
extension SettingCompanyAddressCell {
    func setCell(_ address: String) {
        self.addressLabel.text = address
    }
}
