//
//  YSBlueSwitch.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2023/01/04.
//

import UIKit

class YSBlueSwitch: UIControl {
    
    lazy var barView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 216, green: 216, blue: 216)
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var movableView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 151, green: 151, blue: 151)
        view.layer.cornerRadius = 14
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var indexPath: IndexPath!
    
    var movableViewCenterXAnchor: NSLayoutConstraint!
    
    var isAnimating: Bool = false
    var isOn: Bool = false {
        willSet {
            self.isAnimating = true
        }
        
        didSet {
            UIDevice.lightHaptic()
            
            self.movableViewCenterXAnchor.constant = self.isOn ? 34 : 14
            
            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
                
                if self.isOn {
                    self.barView.backgroundColor = .useRGB(red: 145, green: 218, blue: 255)
                    self.movableView.backgroundColor = .useRGB(red: 25, green: 178, blue: 255)
                    
                } else {
                    self.barView.backgroundColor = .useRGB(red: 216, green: 216, blue: 216)
                    self.movableView.backgroundColor = .useRGB(red: 151, green: 151, blue: 151)
                }
                
            } completion: { finished in
                self.isAnimating = false
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if frame == .zero {
            NSLayoutConstraint.activate([
                self.heightAnchor.constraint(equalToConstant: 48),
                self.widthAnchor.constraint(equalToConstant: 28)
            ])
        }
        
        // setSubviews
        self.addSubview(self.barView)
        self.addSubview(self.movableView)
        
        // setLayouts
        self.movableViewCenterXAnchor = self.movableView.centerXAnchor.constraint(equalTo: self.barView.leadingAnchor, constant: 14)
        NSLayoutConstraint.activate([
            self.barView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.barView.heightAnchor.constraint(equalToConstant: 16),
            self.barView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.barView.widthAnchor.constraint(equalToConstant: 48),
            
            self.movableView.centerYAnchor.constraint(equalTo: self.barView.centerYAnchor),
            self.movableView.heightAnchor.constraint(equalToConstant: 28),
            self.movableViewCenterXAnchor,
            self.movableView.widthAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        if !self.isAnimating {
            self.isOn.toggle()

            self.sendActions(for: .valueChanged)
        }
    }
}
