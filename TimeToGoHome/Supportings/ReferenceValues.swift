//
//  ReferenceValues.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2021/11/26.
//

import UIKit

struct ReferenceValues {
    static let kakaoAuthKey: String = "KakaoAK fcc20fc42b0e0bba71cfae3b09107a38"
    static let dataGoKrKey: String = "0QXt5ziBfkOV7lQFGKAVFuBO8O5YX+Hx0VUu8GauZVX1iJfsZosGtcz/QApzO1/5vmw+GtAz26cVw9nm8Q8LjQ=="
    
    static weak var keyWindow: UIWindow!
    
    static var initialSetting: [String:Any] = {
        if let initialSetting = SupportingMethods.shared.useAppSetting(for: .initialSetting) as? [String:Any] {
            return initialSetting
            
        } else {
            return [:]
        }
    }()
}

// MARK: - Extension of referenceValues for image name
extension ReferenceValues {
    struct ImageName {
        struct Menu {
            static let workRecord = "menuWorkRecord"
            static let workStatistics = "menuWorkStatistics"
            static let vacationUsage = "menuVacationUsage"
            static let joiningDate = "menuJoiningDate"
            static let career = "menuCareer"
            static let leaveCompany = "menuLeaveCompany"
        }
    }
}

// MARK: - Extension of referenceValues for size
extension ReferenceValues {
    struct Size {
        struct Schedule {
            static let normalScheduleHeight: CGFloat = (ReferenceValues.keyWindow.screen.bounds.height - (ReferenceValues.keyWindow.safeAreaInsets.top + 325 + ReferenceValues.keyWindow.safeAreaInsets.bottom)) * 0.27 // 44 + 180 + 75 + 26 + ReferenceValues.keyWindow.safeAreaInsets.bottom
            static let overtimeScheduleHeight: CGFloat = (ReferenceValues.keyWindow.screen.bounds.height - (ReferenceValues.keyWindow.safeAreaInsets.top + 325 + ReferenceValues.keyWindow.safeAreaInsets.bottom)) * 0.17 // 44 + 180 + 75 + 26 + ReferenceValues.keyWindow.safeAreaInsets.bottom
            
            static let changeScheduleDescriptionLabelHeight = (ReferenceValues.keyWindow.screen.bounds.height - (ReferenceValues.keyWindow.safeAreaInsets.top + 325 + ReferenceValues.keyWindow.safeAreaInsets.bottom)) * 0.024 // 44 + 180 + 75 + 26 + ReferenceValues.keyWindow.safeAreaInsets.bottom
        }
        
        struct Record {
            static let normalScheduleHeight: CGFloat = 130
            static let overtimeScheduleHeight: CGFloat = 70
            static let schedulingHeight: CGFloat = 60
            static let changeScheduleDescriptionLabelHeight: CGFloat = 16
        }
    }
}

// MARK: - Extension of referenceValues for push identifier
extension ReferenceValues {
    struct Identifier {
        struct Push {
            static let startingWorkTimeOnSun = "TimeToGoHome.identifier.push.startingWorkTimeOnSun"
            static let startingWorkTimeOnMon = "TimeToGoHome.identifier.push.startingWorkTimeOnMon"
            static let startingWorkTimeOnTue = "TimeToGoHome.identifier.push.startingWorkTimeOnTue"
            static let startingWorkTimeOnWed = "TimeToGoHome.identifier.push.startingWorkTimeOnWed"
            static let startingWorkTimeOnThu = "TimeToGoHome.identifier.push.startingWorkTimeOnThu"
            static let startingWorkTimeOnFri = "TimeToGoHome.identifier.push.startingWorkTimeOnFri"
            static let startingWorkTimeOnSat = "TimeToGoHome.identifier.push.startingWorkTimeOnSat"
            
            static let finishingWorkTimeOclock = "TimeToGoHome.identifier.push.finishingWorkTimeOclock"
            static let finishingWorkTime5minutes = "TimeToGoHome.identifier.push.finishingWorkTime5minutes"
            static let finishingWorkTime10minutes = "TimeToGoHome.identifier.push.finishingWorkTime10minutes"
            static let finishingWorkTime30minutes = "TimeToGoHome.identifier.push.finishingWorkTime30minutes"
            
            static let companyLocation = "TimeToGoHome.identifier.push.companyLocation"
        }
        
        struct Location {
            static let companyLocation = "TimeToGoHome.identifier.location.companyLocation"
        }
    }
}

// MARK: - Extension of UIColor for view color
extension UIColor {
    struct Schedule {
        static var work: UIColor {
            return .useRGB(red: 37, green: 131, blue: 146)
        }
        
        static var overtime: UIColor {
            return .useRGB(red: 250, green: 138, blue: 162)
        }
        
        static var vacation: UIColor {
            return .useRGB(red: 255, green: 197, blue: 63)
        }
        
        static var holiday: UIColor {
            return .useRGB(red: 243, green: 55, blue: 71)
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
    
    struct Record {
        static var work: UIColor {
            return UIColor.Schedule.work
        }
        
        static var overtime: UIColor {
            return UIColor.Schedule.overtime
        }
        
        static var vacation: UIColor {
            return UIColor.Schedule.vacation
        }
        
        static var holiday: UIColor {
            return UIColor.Schedule.holiday
        }
        
        static var scheduling: UIColor {
            return .useRGB(red: 216, green: 216, blue: 216)
        }
        
        static var schedulingDash: UIColor {
            return .useRGB(red: 109, green: 114, blue: 120)
        }
    }
    
    struct Calendar {
        static var vacation: UIColor {
            return .useRGB(red: 255, green: 201, blue: 6)
        }
        
        static var todayMark: UIColor {
            return .useRGB(red: 171, green: 171, blue: 171)
        }
        
        static var selectedDayBottomLine: UIColor {
            return .useRGB(red: 121, green: 121, blue: 121) //.useRGB(red: 234, green: 234, blue: 234)
        }
    }
    
    struct Buttons {
        static var selectedVacation: UIColor {
            return UIColor.Schedule.vacation
        }
        
        static var deselectedVacation: UIColor {
            return .useRGB(red: 216, green: 216, blue: 216)
        }
        
        static var disableSelectedVacation: UIColor {
            return UIColor.Schedule.vacation.withAlphaComponent(0.5)
        }
        
        static var disabledDeselectedVacation: UIColor {
            return .useRGB(red: 216, green: 216, blue: 216).withAlphaComponent(0.5)
        }
        
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
            return .useRGB(red: 26, green: 54, blue: 52) //.useRGB(red: 120, green: 223, blue: 238)
        }
    }
}
