//
//  CompanyAddressCell.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2021/11/26.
//

import UIKit

class CompanyAddressCell: UITableViewCell {
    
    var placeNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.useRGB(red: 0, green: 0, blue: 0)
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var subAddressLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.useRGB(red: 0, green: 0, blue: 0)
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var addressMapButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "addressMapButtonImage"), for: .normal)
        button.setImage(UIImage(named: "addressMapSelectedButtonImage"), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 60, green: 60, blue: 67, alpha: 0.29)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setCellFoundation()
        self.initializeViews()
        self.setTargets()
        self.setGestures()
        self.setDelegates()
        self.setNotificationCenters()
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

// MARK: Extension for essential methods
extension CompanyAddressCell {
    // Set view foundation
    func setCellFoundation() {
        self.selectionStyle = .none
        self.contentView.isUserInteractionEnabled = true
    }
    
    // Initialize views
    func initializeViews() {
        
    }
    
    // Set targets
    func setTargets() {
        
    }
    
    // Set gestures
    func setGestures() {
        
    }
    
    // Set delegates
    func setDelegates() {
        
    }
    
    // Set notificationCenters
    func setNotificationCenters() {
        
    }
    
    // Set subviews
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.placeNameLabel,
            self.subAddressLabel,
            self.addressMapButton,
            self.bottomLineView
        ], to: self)
    }
    
    // Set layouts
    func setLayouts() {
        let safeArea = self.safeAreaLayoutGuide
        
        // placeNameLabel
        NSLayoutConstraint.activate([
            self.placeNameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8),
            self.placeNameLabel.bottomAnchor.constraint(equalTo: safeArea.centerYAnchor),
            self.placeNameLabel.heightAnchor.constraint(equalToConstant: 22),
            self.placeNameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            self.placeNameLabel.trailingAnchor.constraint(equalTo: self.addressMapButton.leadingAnchor, constant: -5)
        ])
        
        // subAddressLabel
        NSLayoutConstraint.activate([
            self.subAddressLabel.topAnchor.constraint(equalTo: safeArea.centerYAnchor),
            self.subAddressLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -8),
            self.subAddressLabel.heightAnchor.constraint(equalToConstant: 22),
            self.subAddressLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            self.subAddressLabel.trailingAnchor.constraint(equalTo: self.addressMapButton.leadingAnchor, constant: -5)
        ])
        
        // Address map button layout
        NSLayoutConstraint.activate([
            self.addressMapButton.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            self.addressMapButton.heightAnchor.constraint(equalToConstant: 35),
            self.addressMapButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            self.addressMapButton.widthAnchor.constraint(equalToConstant: 29)
        ])
        
        // Bottom line view layout
        NSLayoutConstraint.activate([
            self.bottomLineView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.bottomLineView.heightAnchor.constraint(equalToConstant: 1),
            self.bottomLineView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.bottomLineView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}

// MARK: - Methods added
extension CompanyAddressCell {
    func setCell(_ placeName: String, address: String, isSelected: Bool, tag: Int) {
        self.placeNameLabel.text = placeName
        self.subAddressLabel.text = address
        self.addressMapButton.isSelected = isSelected
        self.addressMapButton.tag = tag
    }
}
