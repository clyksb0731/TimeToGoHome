//
//  SupportingMethods.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2021/11/26.
//

import UIKit

/**
 Variables for app setting on UserDefaults
 */
enum PListVariable: String {
    case workType
    case workTimeValueRange
    case startingWorkTimeValue
    case lunchTimeValue
    case initiallySetting
}

enum CoverViewState {
    case on
    case off
}

class SupportingMethods {
    private var coverViewArray: Array<UIView> = []
    
    static let shared = SupportingMethods()
    
    private init() {
        
    }
}

// MARK: - Methods added
extension SupportingMethods {
    // MARK: Set app setting on UserDefaults
    func setAppSetting(with value: Any?, for key: PListVariable) {
        if let value = value {
            if var appSetting = UserDefaults.standard.dictionary(forKey: "appSetting") {
                appSetting.updateValue(value, forKey: key.rawValue)
                UserDefaults.standard.set(appSetting, forKey: "appSetting")
                
            } else {
                var appSetting: [String:Any] = [:]
                appSetting.updateValue(value, forKey: key.rawValue)
                UserDefaults.standard.set(appSetting, forKey: "appSetting")
            }
            
            
        } else {
            if var appSetting = UserDefaults.standard.dictionary(forKey: "appSetting") {
                appSetting.removeValue(forKey: key.rawValue)
                UserDefaults.standard.set(appSetting, forKey: "appSetting")
                
            } else {
                let appSetting: [String:Any] = [:]
                UserDefaults.standard.set(appSetting, forKey: "appSetting")
            }
        }
    }
    
    // MARK: Use app setting from UserDefaults
    func useAppSetting(for key: PListVariable) -> Any? {
        guard let appSetting = UserDefaults.standard.dictionary(forKey: "appSetting") else { return nil}
        guard let value = appSetting[key.rawValue] else { return nil }
        
        return value
    }
    
    // MARK: Get the specific constraint
    func getTheSpecificConstraintWithIdentifier(_ identifier: String, from view: UIView) -> NSLayoutConstraint? {
        var constraint: NSLayoutConstraint?
        
        for element in view.constraints {
            if element.identifier == identifier {
                constraint = element
                
                break
            }
        }
        
        return constraint
    }
    
    // MARK: Add Subviews
    func addSubviews(_ views: [UIView], to: UIView) {
        for view in views {
            to.addSubview(view)
        }
    }
    
    // MARK: Get current time seconds
    class func getCurrentTimeSeconds() -> Int {
        return Int(CFAbsoluteTimeGetCurrent())
    }
    
    // MARK: Cover view
    func turnCoverView(_ state: CoverViewState, on: UIView) {
        switch state {
        case .on:
            // Cover View
            let coverView = UIView()
            coverView.backgroundColor = UIColor.useRGB(red: 0, green: 0, blue: 0, alpha: 0.3)
            coverView.translatesAutoresizingMaskIntoConstraints = false
            
            // Activity Indicator View
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.color = .white
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            
            coverView.addSubview(activityIndicator)
            on.addSubview(coverView)
            
            self.coverViewArray.append(coverView)
            
            NSLayoutConstraint.activate([
                // Activity Indicator
                activityIndicator.centerYAnchor.constraint(equalTo: coverView.centerYAnchor),
                activityIndicator.centerXAnchor.constraint(equalTo: coverView.centerXAnchor),
                
                // Cover view
                coverView.topAnchor.constraint(equalTo: on.topAnchor),
                coverView.bottomAnchor.constraint(equalTo: on.bottomAnchor),
                coverView.leadingAnchor.constraint(equalTo: on.leadingAnchor),
                coverView.trailingAnchor.constraint(equalTo: on.trailingAnchor)
            ])
            
            activityIndicator.startAnimating()
            
        case .off:
            if let view = on.subviews.last {
                for i in 0..<self.coverViewArray.count {
                    if view === self.coverViewArray[i] {
                        if let activityIndicator = view.subviews.first as? UIActivityIndicatorView {
                            activityIndicator.stopAnimating()
                        }
                        
                        view.removeFromSuperview()
                        
                        self.coverViewArray.remove(at: i)
                        break;
                    }
                }
            }
        }
    }
    
    func determineAdditionalHourAndMinuteUsingMinute(_ minutes: Int) -> String {
        let hours = minutes / 60
        let minuteLeft = minutes % 60
        
        if hours > 0 {
            if minuteLeft == 0 {
                return "+ \(hours)시간"
                
            } else {
                return "+ \(hours)시간 \(minuteLeft)분"
            }
            
        } else {
            return "+ \(minuteLeft)분"
        }
    }
    
    func determineAdditionalHourAndMinuteUsingSecond(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minuteLeft = (seconds % 3600) / 60
        
        if hours > 0 {
            if minuteLeft == 0 {
                return "+ \(hours)시간"
                
            } else {
                return "+ \(hours)시간 \(minuteLeft)분"
            }
            
        } else {
            return "+ \(minuteLeft)분"
        }
    }
}

// MARK: - Other Extensions
// MARK: UIDevice haptics
extension UIDevice {
    // MARK: Make Haptic Effect
    static func softHaptic() {
        let haptic = UIImpactFeedbackGenerator(style: .soft)
        haptic.impactOccurred()
    }
    
    static func lightHaptic() {
        let haptic = UIImpactFeedbackGenerator(style: .light)
        haptic.impactOccurred()
    }
    
    static func heavyHaptic() {
        let haptic = UIImpactFeedbackGenerator(style: .heavy)
        haptic.impactOccurred()
    }
}

// MARK: UIColor to be possible to get color using 0 ~ 255 integer
extension UIColor {
    class func useRGB(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: red / CGFloat(255), green: green / CGFloat(255), blue: blue / CGFloat(255), alpha: alpha)
    }
}

extension CALayer {
    func useSketchShadow(color: UIColor, alpha: Float, x: CGFloat, y: CGFloat, blur: CGFloat, spread: CGFloat) {
        self.masksToBounds = false
        self.shadowColor = color.cgColor
        self.shadowOpacity = alpha
        self.shadowOffset = CGSize(width: x, height: y)
        self.shadowRadius = blur / 2.0
        
        if spread == 0 {
            self.shadowPath = nil
            
        } else {
            let dx = -spread
            let rect = self.bounds.insetBy(dx: dx, dy: dx)
            self.shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

extension UIPickerView {
    func setPickerComponentNames(names: [Int:String]) { // [component index:component name]
            let fontSize:CGFloat = 20
            let labelWidth:CGFloat = self.frame.size.width / CGFloat(self.numberOfComponents)
            //let x:CGFloat = self.frame.origin.x
            let y:CGFloat = (self.frame.size.height / 2) - (fontSize / 2)

            for (i, name) in names {
                let label = UILabel()
                label.frame = CGRect(x: labelWidth * CGFloat(i), y: y, width: labelWidth, height: fontSize)
                label.font = UIFont.systemFont(ofSize: fontSize, weight: .light)
                label.backgroundColor = .clear
                label.textAlignment = .left
                label.text = name
                self.addSubview(label)
            }
        }
}
