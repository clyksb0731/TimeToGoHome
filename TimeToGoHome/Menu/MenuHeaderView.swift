//
//  MenuHeaderView.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/11/16.
//

import UIKit

class MenuHeaderView: UITableViewHeaderFooterView {
    
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .useRGB(red: 120, green: 120, blue: 120)
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
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
extension MenuHeaderView: EssentialCellHeaderMethods {
    func setViewFoundation() {
        self.layer.backgroundColor = UIColor.white.cgColor
    }
    
    func initializeObjects() {
        
    }
    
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.categoryLabel
        ], to: self)
    }
    
    func setLayouts() {
        let safeArea = self.safeAreaLayoutGuide
        
        // categoryLabel
        NSLayoutConstraint.activate([
            self.categoryLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.categoryLabel.heightAnchor.constraint(equalToConstant: 19),
            self.categoryLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -8),
            self.categoryLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16)
        ])
    }
}

// MARK: - Extension for methods added
extension MenuHeaderView {
    func setHeaderView(categoryText text: String) {
        self.categoryLabel.text = text
    }
}
