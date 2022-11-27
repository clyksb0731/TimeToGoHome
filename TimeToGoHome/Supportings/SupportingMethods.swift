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
    // 초기 설정
    case initialSetting
    case timeDateForStartingTodayOfStaggeredSchedule
    case dateForFinishedSchedule
}

enum InitialSetting: String {
    // 회사 정보
    case companyName // 현 회사이름
    case joiningDate // 현 입사날짜
    case leavingDate // 퇴사날짜
    case companyAddress // 현 회사주소
    case companyLatitude // 현 회사위치 위도
    case companyLongitude // 현 회사위치 경도
    
    // 근무 정보
    case workType // 근무형태
    case morningStartingworkTimeValueRange // 출근시간범위 (빠른/늦은)
    case morningStartingWorkTimeValue // 출근시간 (그냥 출근시간)
    case afternoonStartingworkTimeValueRange // 오후 출근시간범위 (빠른/늦은)
    case afternoonStartingworkTimeValue // 오후 출근시간 (그냥 오후 출근시간)
    case lunchTimeValue // 점심시간
    case isIgnoredLunchTimeForHalfVacation // 반차 시 점심시간 무시 여부
    
    // 휴무 정보
    case holidays // 정기 휴무 요일
    case annualVacationType // 휴가기준 (회계연도/입사날짜)
    case numberOfTotalVacations // 연차 개수
}

enum CoverViewState {
    case on
    case off
}

class SupportingMethods {
    private var coverView: UIView?
    
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
    
    // MARK: Cover view
    func turnCoverView(_ state: CoverViewState, on: UIView?) {
        guard let on = on else {
            return
        }
        
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
            self.coverView = coverView
            
            on.addSubview(coverView)
            
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
            for view in on.subviews {
                if view === self.coverView {
                    if let activityIndicator = view.subviews.first as? UIActivityIndicatorView {
                        activityIndicator.stopAnimating()
                    }
                    view.removeFromSuperview()
                    self.coverView = nil
                    
                    break
                }
            }
        }
    }
    
    // MARK: Alert view
    func makeAlert(on: UIViewController, withTitle title: String, andMessage message: String, okAction: UIAlertAction = UIAlertAction(title: "확인", style: .default), cancelAction: UIAlertAction? = nil, completion: (() -> ())? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(okAction)
        if let cancelAction = cancelAction {
            alertVC.addAction(cancelAction)
        }
        
        on.present(alertVC, animated: false, completion: completion)
    }
    
    // MARK: About time
    func makeDateFormatter(_ format: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format
        
        return dateFormatter
    }
    
    func makeDateWithYear(_ year: Int, month: Int, andDay day: Int = 1) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = .current
        
        let dateComponents = DateComponents(year: year, month: month, day: day)
        
        return calendar.date(from: dateComponents)!
    }
    
    func getWeekdayOfDate(_ date: Date) -> Int { // 1: sunday ~ 7: saturday
        var calendar = Calendar.current
        calendar.timeZone = .current
        let dateComponents = calendar.dateComponents([.weekday], from: date)
        
        return dateComponents.weekday!
    }
    
    func getYearMonthAndDayOf(_ date: Date) -> (year: Int, month: Int, day: Int) {
        var calendar = Calendar.current
        calendar.timeZone = .current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        
        return (dateComponents.year!, dateComponents.month!, dateComponents.day!)
    }
    
    func getWeeksOfMonthFor(_ date: Date) -> Int {
        var calendar = Calendar.current
        calendar.timeZone = .current
        let weeksOfMonth = calendar.range(of: .weekOfMonth, in: .month, for: date)
        
        return (weeksOfMonth?.count)!
    }
    
    func getDaysOfMonthFor(_ date: Date) -> Int {
        var calendar = Calendar.current
        calendar.timeZone = .current
        let daysOfMonth = calendar.range(of: .day, in: .month, for: date)
        
        return (daysOfMonth?.count)!
    }
    
    func getFirstWeekdayFor(_ date: Date) -> Int {
        var calendar = Calendar.current
        calendar.timeZone = .current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        var firstDayDateComponents = DateComponents(year: dateComponents.year!, month: dateComponents.month!, day: 1)
        let firstDate = calendar.date(from: firstDayDateComponents)!
        firstDayDateComponents = calendar.dateComponents([.weekday], from: firstDate)
        
        return firstDayDateComponents.weekday!
    }
    
    func determineAdditionalHourAndMinuteUsingMinute(_ minutes: Int) -> String {
        let hours = minutes / 60
        let minutesLeft = minutes % 60
        
        if hours > 0 {
            if minutesLeft == 0 {
                return "+ \(hours)시간"
                
            } else {
                return "+ \(hours)시간 \(minutesLeft)분"
            }
            
        } else {
            return "+ \(minutesLeft)분"
        }
    }
    
    func determineAdditionalHourAndMinuteUsingSecond(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutesLeft = (seconds % 3600) / 60
        
        if hours > 0 {
            if minutesLeft == 0 {
                return "+ \(hours)시간"
                
            } else {
                return "+ \(hours)시간 \(minutesLeft)분"
            }
            
        } else {
            return "+ \(minutesLeft)분"
        }
    }
    
    func makeHourAndMinuteAttributedStringUsingSecond(_ seconds: Int, withValueAttributes valueAttributes: [NSAttributedString.Key : Any], andWithMarkAttributes markAttributes: [NSAttributedString.Key : Any]) -> NSAttributedString {
        let hours = seconds / 3600
        let minutesLeft = (seconds % 3600) / 60
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        
        let attributedText = NSMutableAttributedString()
        
        let hoursValue = NSAttributedString(string: "\(hours)", attributes: valueAttributes)
        let hoursMark = NSAttributedString(string: " 시간", attributes: markAttributes)
        let minutesValue = NSAttributedString(string: " \(minutesLeft)", attributes: valueAttributes)
        let minutesMark = NSAttributedString(string: " 분", attributes: markAttributes)
        
        if hours > 0 {
            if minutesLeft == 0 {
                attributedText.append(hoursValue)
                attributedText.append(hoursMark)
                
            } else {
                attributedText.append(hoursValue)
                attributedText.append(hoursMark)
                attributedText.append(minutesValue)
                attributedText.append(minutesMark)
            }
            
        } else {
            attributedText.append(minutesValue)
            attributedText.append(minutesMark)
        }
        
        return attributedText
    }
    
    func makeTimeDateWithValue(_ value: Double) -> Date? {
        let hour = (Int(value * 10)) / 10
        let minute = Int((Double((Int(value * 10)) % 10) / 10.0) * 60)
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        let todayDateComponents = DateComponents(timeZone: TimeZone.current, year: dateComponents.year!, month: dateComponents.month!, day: dateComponents.day!, hour: hour, minute: minute)
        
        return calendar.date(from: todayDateComponents)
    }
    
    class func getCurrentTimeSeconds() -> Int {
        return Int(CFAbsoluteTimeGetCurrent())
        
        // FIXME: For test
        //return self.makeTempTimeSeconds(hour: 17, minute: 3, second: 0)
    }
    
    class func getYearMonthAndDayOf(_ date: Date) -> (year: Int, month: Int, day: Int) {
        var calendar = Calendar.current
        calendar.timeZone = .current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        
        return (dateComponents.year!, dateComponents.month!, dateComponents.day!)
    }
    
    // Make temp time seconds for test
    class func makeTempTimeSeconds(year: Int = getYearMonthAndDayOf(Date()).year,
                                   month: Int = getYearMonthAndDayOf(Date()).month,
                                   day: Int = getYearMonthAndDayOf(Date()).day,
                                   hour: Int, minute: Int, second: Int) -> Int {
        var calendar = Calendar.current
        calendar.timeZone = .current
        
        let timeComponents = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
        
        return Int(calendar.date(from: timeComponents)!.timeIntervalSinceReferenceDate)
    }
    
    // Make temp time date for test
    class func makeTempTimeDate(year: Int = getYearMonthAndDayOf(Date()).year,
                                month: Int = getYearMonthAndDayOf(Date()).month,
                                day: Int = getYearMonthAndDayOf(Date()).day,
                                hour: Int, minute: Int, second: Int) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = .current
        
        let timeComponents = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
        
        return calendar.date(from: timeComponents)!
    }
    
    // MARK: About constraint
    func makeSameBoundConstraints(_ firstView: UIView, _ secondView: UIView) {
        NSLayoutConstraint.activate([
            firstView.topAnchor.constraint(equalTo: secondView.topAnchor),
            firstView.bottomAnchor.constraint(equalTo: secondView.bottomAnchor),
            firstView.leadingAnchor.constraint(equalTo: secondView.leadingAnchor),
            firstView.trailingAnchor.constraint(equalTo: secondView.trailingAnchor)
        ])
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

// MARK: - View Protocol
protocol EssentialViewMethods {
    func setViewFoundation()
    func initializeObjects()
    func setDelegates()
    func setGestures()
    func setNotificationCenters()
    func setSubviews()
    func setLayouts()
}

// MARK: - Cell & Header Protocol
protocol EssentialCellHeaderMethods {
    func setViewFoundation()
    func initializeObjects()
    func setSubviews()
    func setLayouts()
}
