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
        view.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 0, blur: 3, spread: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var indexPath: IndexPath!
    
    var movableViewCenterXAnchor: NSLayoutConstraint!
    
    var isMoving: Bool = false
    var isOn: Bool {
        willSet {
            self.isMoving = true
        }
        
        didSet {
            self.movableViewCenterXAnchor.constant = self.isOn ? 30 : 14
            
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
                self.isMoving = false
            }
        }
    }

    init(_ isOn: Bool = false, frame: CGRect = .zero) {
        self.isOn = isOn
        
        super.init(frame: frame)
        
        if self.isOn {
            self.barView.backgroundColor = .useRGB(red: 145, green: 218, blue: 255)
            self.movableView.backgroundColor = .useRGB(red: 25, green: 178, blue: 255)
            
        } else {
            self.barView.backgroundColor = .useRGB(red: 216, green: 216, blue: 216)
            self.movableView.backgroundColor = .useRGB(red: 151, green: 151, blue: 151)
        }
        
        if frame == .zero {
            NSLayoutConstraint.activate([
                self.heightAnchor.constraint(equalToConstant: 28),
                self.widthAnchor.constraint(equalToConstant: 44)
            ])
        }
        
        // setSubviews
        self.addSubview(self.barView)
        self.addSubview(self.movableView)
        
        // setLayouts
        self.movableViewCenterXAnchor = self.movableView.centerXAnchor.constraint(equalTo: self.barView.leadingAnchor, constant: self.isOn ? 30 : 14)
        NSLayoutConstraint.activate([
            self.barView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.barView.heightAnchor.constraint(equalToConstant: 16),
            self.barView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.barView.widthAnchor.constraint(equalToConstant: 44),
            
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

        if !self.isMoving {
            self.isOn.toggle()
            
            UIDevice.lightHaptic()

            self.sendActions(for: .valueChanged)
        }
    }
    
    func setOn(_ on: Bool, animated: Bool) {
        self.isMoving = true
        
        self.isOn = on
        
        self.movableViewCenterXAnchor.constant = on ? 30 : 14
        
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
                
                if on {
                    self.barView.backgroundColor = .useRGB(red: 145, green: 218, blue: 255)
                    self.movableView.backgroundColor = .useRGB(red: 25, green: 178, blue: 255)
                    
                } else {
                    self.barView.backgroundColor = .useRGB(red: 216, green: 216, blue: 216)
                    self.movableView.backgroundColor = .useRGB(red: 151, green: 151, blue: 151)
                }
                
            } completion: { finished in
                self.isMoving = false
            }
            
        } else {
            if on {
                self.barView.backgroundColor = .useRGB(red: 145, green: 218, blue: 255)
                self.movableView.backgroundColor = .useRGB(red: 25, green: 178, blue: 255)
                
            } else {
                self.barView.backgroundColor = .useRGB(red: 216, green: 216, blue: 216)
                self.movableView.backgroundColor = .useRGB(red: 151, green: 151, blue: 151)
            }
            
            self.isMoving = false
        }
    }
}
