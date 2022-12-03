//
//  ReferenceValues.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2021/11/26.
//

import UIKit

struct ReferenceValues {
    static let kakaoAuthKey: String = "KakaoAK fcc20fc42b0e0bba71cfae3b09107a38"
    
    static var initialSetting: [String:Any] = {
        if let initialSetting = SupportingMethods.shared.useAppSetting(for: .initialSetting) as? [String:Any] {
            return initialSetting
            
        } else {
            return [:]
        }
    }()
}

// MARK: - Extension of referenceValues for size
extension ReferenceValues {
    struct size {
        struct schedule {
            static let normalScheduleHeight: CGFloat = (UIScreen.main.bounds.height - (UIWindow().safeAreaInsets.top + 44 + 180 + 75 + 26 + UIWindow().safeAreaInsets.bottom)) * 0.27
            static let overtimeScheduleHeight: CGFloat = (UIScreen.main.bounds.height - (UIWindow().safeAreaInsets.top + 44 + 180 + 75 + 26 + UIWindow().safeAreaInsets.bottom)) * 0.17
            
            static let changeScheduleDescriptionLabelHeight = (UIScreen.main.bounds.height - (UIWindow().safeAreaInsets.top + 44 + 180 + 75 + 26 + UIWindow().safeAreaInsets.bottom)) * 0.024
        }
        
        struct record {
            static let normalScheduleHeight: CGFloat = 130
            static let overtimeScheduleHeight: CGFloat = 70
            static let schedulingHeight: CGFloat = 60
            static let changeScheduleDescriptionLabelHeight: CGFloat = 16
        }
    }
}

// MARK: - Extension of UIColor for view color
extension UIColor {
    struct schedule {
        static var work: UIColor {
            return .useRGB(red: 125, green: 243, blue: 110)
        }
        
        static var overtime: UIColor {
            return .useRGB(red: 239, green: 119, blue: 119)
        }
        
        static var vacation: UIColor {
            return .useRGB(red: 120, green: 223, blue: 238)
        }
        
        static var holiday: UIColor {
            return .useRGB(red: 252, green: 247, blue: 143)
        }
        
        static var scheduling: UIColor {
            return .useRGB(red: 235, green: 235, blue: 235)
        }
        
        static var schedulingDash: UIColor {
            return .useRGB(red: 189, green: 189, blue: 189)
        }
        
        static var finishWork: UIColor {
            return .black
        }
    }
    
    struct record {
        static var work: UIColor {
            return .useRGB(red: 125, green: 243, blue: 110)
        }
        
        static var overtime: UIColor {
            return .useRGB(red: 239, green: 119, blue: 119)
        }
        
        static var vacation: UIColor {
            return .useRGB(red: 120, green: 223, blue: 238)
        }
        
        static var holiday: UIColor {
            return .useRGB(red: 252, green: 247, blue: 143)
        }
        
        static var scheduling: UIColor {
            return .useRGB(red: 216, green: 216, blue: 216)
        }
        
        static var schedulingDash: UIColor {
            return .useRGB(red: 109, green: 114, blue: 120)
        }
    }
    
    struct calendar {
        static var vacation: UIColor {
            return .useRGB(red: 110, green: 217, blue: 228)
        }
        
        static var todayMark: UIColor {
            return .useRGB(red: 171, green: 171, blue: 171)
        }
        
        static var selectedDayBottomLine: UIColor {
            return .useRGB(red: 121, green: 121, blue: 121) //.useRGB(red: 234, green: 234, blue: 234)
        }
    }
    
    struct buttons {
        static var initialActiveBottom: UIColor {
            return .useRGB(red: 146, green: 243, blue: 205)
        }
        
        static var initialInactiveBottom: UIColor {
            return .useRGB(red: 238, green: 238, blue: 238)
        }
        
        static var workType: UIColor {
            return .useRGB(red: 78, green: 216, blue: 220)
        }
        
        static var initializeNewCompany: UIColor {
            return .useRGB(red: 120, green: 223, blue: 238)
        }
    }
}
