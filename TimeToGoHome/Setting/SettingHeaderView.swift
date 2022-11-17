//
//  SettingHeaderView.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/11/17.
//

import UIKit

class SettingHeaderView: UITableViewHeaderFooterView {
    
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .useRGB(red: 60, green: 60, blue: 60, alpha: 0.6)
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 60, green: 60, blue: 67, alpha: 0.29)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.setViewFoundation()
        self.initializeObjects()
        self.setSubviews()
        self.setLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Extension for essential methods
extension SettingHeaderView: EssentialCellHeaderMethods {
    func setViewFoundation() {
        self.layer.backgroundColor = UIColor.useRGB(red: 242, green: 242, blue: 247).cgColor
    }
    
    func initializeObjects() {
        
    }
    
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.categoryLabel,
            self.bottomLineView
        ], to: self)
    }
    
    func setLayouts() {
        let safeArea = self.safeAreaLayoutGuide
        
        // categoryLabel
        NSLayoutConstraint.activate([
            self.categoryLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 14),
            self.categoryLabel.heightAnchor.constraint(equalToConstant: 18),
            self.categoryLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -6),
            self.categoryLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16)
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
extension SettingHeaderView {
    func setHeaderView(categoryText text: String) {
        self.categoryLabel.text = text
    }
}
