//
//  WhiteButtonView.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/02/09.
//

import UIKit

class WhiteButtonView: UIView {
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var font: UIFont {
        set {
            self.label.font = newValue
        }
        
        get {
            return self.label.font
        }
    }
    
    var textAlignment: NSTextAlignment {
        set {
            self.label.textAlignment = newValue
        }
        
        get {
            return self.label.textAlignment
        }
    }
    
    var title: String? {
        set {
            self.label.text = newValue
        }
        
        get {
            return self.label.text
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            self.alpha = self.isSelected ? 1.0 : 0.5
        }
    }
    
    var isEnabled: Bool = true {
        didSet {
            self.button.isEnabled = self.isEnabled
            self.isSelected = self.isEnabled;
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setViewFoundation()
        self.setSubviews()
        self.setLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("----------------------------------- WhiteButtonView disposed -----------------------------------")
    }
}

// MARK: - Extension for Essential methods
extension WhiteButtonView {
    func setViewFoundation() {
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 2
    }
    
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.label,
            self.button
        ], to: self)
    }
    
    func setLayouts() {
        // Label layout
        NSLayoutConstraint.activate([
            self.label.topAnchor.constraint(equalTo: self.topAnchor),
            self.label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        // Button layout
        NSLayoutConstraint.activate([
            self.button.topAnchor.constraint(equalTo: self.topAnchor),
            self.button.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.button.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}

// MARK: - Extension for methods added
extension WhiteButtonView {
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        self.button.addTarget(target, action: action, for: controlEvents)
    }
}

// MARK: - Extension for selector methods
extension WhiteButtonView {
    
}
