//
//  DayButtonView.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2021/11/26.
//

import UIKit

enum Days {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}

class DayButtonView: UIView {
    var dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
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
            return coverButton.tag
        }
        
        set {
            self.coverButton.tag = newValue
        }
    }
    
    var day: Days
    
    var isSelected: Bool = false {
        didSet {
            self.determineView(self.day)
        }
    }
    
    init(day: Days) {
        self.day = day
        
        super.init(frame: CGRect.zero)
        //super.init(frame: CGRect(x: 0, y: 0, width: 26, height: 36))
        
        self.setViewFoundation()
        self.setLayouts()
        self.determineView(day)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extension for Methods added
extension DayButtonView {
    func setViewFoundation() {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
    }
    
    func determineView(_ day: Days) {
        switch day {
        case .sunday:
            self.dayLabel.text = "일"
            
            if self.isSelected {
                self.backgroundColor = UIColor.useRGB(red: 247, green: 121, blue: 121)
                
            } else {
                self.backgroundColor = UIColor.useRGB(red: 247, green: 190, blue: 190)
            }
            
        case .monday:
            self.dayLabel.text = "월"
            
            if self.isSelected {
                self.backgroundColor = UIColor.useRGB(red: 93, green: 168, blue: 242)
                
            } else {
                self.backgroundColor = UIColor.useRGB(red: 190, green: 219, blue: 247)
            }
            
        case .tuesday:
            self.dayLabel.text = "화"
            
            if self.isSelected {
                self.backgroundColor = UIColor.useRGB(red: 93, green: 168, blue: 242)
                
            } else {
                self.backgroundColor = UIColor.useRGB(red: 190, green: 219, blue: 247)
            }
            
        case .wednesday:
            self.dayLabel.text = "수"
            
            if self.isSelected {
                self.backgroundColor = UIColor.useRGB(red: 93, green: 168, blue: 242)
                
            } else {
                self.backgroundColor = UIColor.useRGB(red: 190, green: 219, blue: 247)
            }
            
        case .thursday:
            self.dayLabel.text = "목"
            
            if self.isSelected {
                self.backgroundColor = UIColor.useRGB(red: 93, green: 168, blue: 242)
                
            } else {
                self.backgroundColor = UIColor.useRGB(red: 190, green: 219, blue: 247)
            }
            
        case .friday:
            self.dayLabel.text = "금"
            
            if self.isSelected {
                self.backgroundColor = UIColor.useRGB(red: 93, green: 168, blue: 242)
                
            } else {
                self.backgroundColor = UIColor.useRGB(red: 190, green: 219, blue: 247)
            }
            
        case .saturday:
            self.dayLabel.text = "토"
            
            if self.isSelected {
                self.backgroundColor = UIColor.useRGB(red: 247, green: 121, blue: 121)
                
            } else {
                self.backgroundColor = UIColor.useRGB(red: 247, green: 190, blue: 190)
            }
        }
    }
    
    func setLayouts() {
        self.addSubview(self.dayLabel)
        self.addSubview(self.coverButton)
        
        // Witdh, height layout
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 36),
            self.widthAnchor.constraint(equalToConstant: 26)
        ])
        
        // Day label layout
        NSLayoutConstraint.activate([
            self.dayLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.dayLabel.heightAnchor.constraint(equalToConstant: 22),
            self.dayLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.dayLabel.widthAnchor.constraint(equalToConstant: 15)
        ])
        
        // Cover button layout
        NSLayoutConstraint.activate([
            self.coverButton.topAnchor.constraint(equalTo: self.topAnchor),
            self.coverButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.coverButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.coverButton.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        self.coverButton.addTarget(target, action: action, for: controlEvents)
    }
}
