//
//  SettingCompanyAddressCell.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2023/01/08.
//

import UIKit

class SettingCompanyAddressCell: UITableViewCell {
    
    lazy var placeNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var subAddressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .regular)
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
            self.placeNameLabel,
            self.subAddressLabel,
            self.bottomLine
        ], to: self)
    }
    
    func setLayouts() {
        let safeArea = self.safeAreaLayoutGuide
        
        // addressLabel
        NSLayoutConstraint.activate([
            self.placeNameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8),
            self.placeNameLabel.heightAnchor.constraint(equalToConstant: 22),
            self.placeNameLabel.bottomAnchor.constraint(equalTo: safeArea.centerYAnchor),
            self.placeNameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            self.placeNameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // subAddressLabel
        NSLayoutConstraint.activate([
            self.subAddressLabel.topAnchor.constraint(equalTo: safeArea.centerYAnchor),
            self.subAddressLabel.heightAnchor.constraint(equalToConstant: 22),
            self.subAddressLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -8),
            self.subAddressLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            self.subAddressLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
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
    func setCell(_ placeName: String?, address: String?) {
        self.placeNameLabel.text = placeName
        self.subAddressLabel.text = address
    }
}
