//
//  VacationButtonView.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/04/09.
//

import UIKit

class VacationButtonView: UIView {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var coverButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override var tag: Int {
        get {
            return self.coverButton.tag
        }
        
        set {
            self.coverButton.tag = newValue
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            guard oldValue != self.isSelected else {
                return
            }
            
            self.backgroundColor = {
                if self.isEnable {
                    if self.isSelected {
                        return .Buttons.selectedVacation
                        
                    } else {
                        return .Buttons.deselectedVacation
                    }
                    
                } else {
                    if self.isSelected {
                        return .Buttons.disableSelectedVacation
                        
                    } else {
                        return .Buttons.disabledDeselectedVacation
                    }
                }
            }()
        }
    }
    
    var isEnable: Bool = true {
        didSet {
            guard oldValue != self.isEnable else {
                return
            }
            
            self.backgroundColor = {
                if self.isEnable {
                    if self.isSelected {
                        return .useRGB(red: 110, green: 217, blue: 228)
                        
                    } else {
                        return .useRGB(red: 216, green: 216, blue: 216)
                    }
                    
                } else {
                    if self.isSelected {
                        return .useRGB(red: 110, green: 217, blue: 228, alpha: 0.5)
                        
                    } else {
                        return .useRGB(red: 216, green: 216, blue: 216, alpha: 0.5)
                    }
                }
            }()
            
            self.titleLabel.textColor = self.isEnable ? .black : .useRGB(red: 0, green: 0, blue: 0, alpha: 0.5)
            
            self.layer.shadowOpacity = self.isEnable ? 0.5 : 0
            
            self.coverButton.isEnabled = self.isEnable
        }
    }
    
    init(title: String, isSelected: Bool = false, font: UIFont = .systemFont(ofSize: 18), textAlignment: NSTextAlignment = .center, textColor: UIColor = .black) {
        super.init(frame: .zero)
        
        self.setViewFoundation()
        
        self.titleLabel.text = title
        self.titleLabel.font = font
        self.titleLabel.textAlignment = textAlignment
        self.titleLabel.textColor = textColor
        self.isSelected = isSelected
        
        self.setSubviews()
        self.setLayouts()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extension for essential methods
extension VacationButtonView {
    func setViewFoundation() {
        self.backgroundColor = .useRGB(red: 216, green: 216, blue: 216)
        self.layer.cornerRadius = 2
        self.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
    }
    
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.titleLabel,
            self.coverButton
        ], to: self)
    }
    
    func setLayouts() {
        let safeArea = self.safeAreaLayoutGuide
        
        // titleLabel layout
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.titleLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // coverButton layout
        NSLayoutConstraint.activate([
            self.coverButton.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.coverButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.coverButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.coverButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}

// MARK: - Extension for methods added
extension VacationButtonView {
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        self.coverButton.addTarget(target, action: action, for: controlEvents)
    }
}
    
