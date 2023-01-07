//
//  SupportingMethods.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2021/11/26.
//

import UIKit
import CoreLocation

/**
 Variables for app setting on UserDefaults
 */
enum PListVariable: String {
    // 초기 설정
    case initialSetting
    case timeDateForStartingTodayOfStaggeredSchedule
    case dateForFinishedSchedule
    case pushActivation
    case alertSettingStartingWorkTime
    case alertFinishingWorkTime
    case alertCompanyLocation
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
    case regularHolidays // 정기 휴무 요일
    case annualPaidHolidayType // 휴가기준 (회계연도/입사날짜)
    case annualPaidHolidays // 연차 개수
}

enum CoverViewState {
    case on
    case off
}

class SupportingMethods {
    private var coverView: UIView?
    private var instantView: UIView?
    
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
    
    // MARK: Make Dash layer
    func makeDashLayer(dashColor: UIColor, width: CGFloat, height: CGFloat, cornerRadius: CGFloat) -> CAShapeLayer {
        let dashLayer = CAShapeLayer()
        dashLayer.strokeColor = dashColor.cgColor
        dashLayer.lineWidth = 2
        dashLayer.lineDashPattern = [2,2]
        dashLayer.fillColor = nil
        dashLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width, height: height), cornerRadius: cornerRadius).cgPath
        
        return dashLayer
    }
    
    // MARK: Instant view
    enum InstantMessagePosition {
        case top
        case bottom
    }
    
    func makeInstantViewWithText(_ text: String, duration: TimeInterval, on vc: UIViewController, withPosition position: InstantMessagePosition) {
        let alertView: UIView = {
            let view = UIView()
            view.backgroundColor = .useRGB(red: 24, green: 163, blue: 240, alpha: 0.6)
            view.layer.cornerRadius = 20
            view.isHidden = true
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        let alertLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 17, weight: .bold)
            label.textColor = .white
            label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        
        alertView.addSubview(alertLabel)
        vc.view.addSubview(alertView)
        
        switch position {
        case .top:
            // alertView
            NSLayoutConstraint.activate([
                alertView.topAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.topAnchor, constant: 30),
                alertView.heightAnchor.constraint(equalToConstant: 40),
                alertView.centerXAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.centerXAnchor),
                alertView.widthAnchor.constraint(greaterThanOrEqualToConstant: 50)
            ])
            
        case .bottom:
            // alertView
            NSLayoutConstraint.activate([
                alertView.bottomAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
                alertView.heightAnchor.constraint(equalToConstant: 40),
                alertView.centerXAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.centerXAnchor),
                alertView.widthAnchor.constraint(greaterThanOrEqualToConstant: 50)
            ])
        }
        
        
        // alertLabel
        NSLayoutConstraint.activate([
            alertLabel.centerYAnchor.constraint(equalTo: alertView.centerYAnchor),
            alertLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20),
            alertLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20)
        ])
        
        // Alert label
        alertLabel.text = text
        alertView.alpha = 1
        alertView.isHidden = false
        UIView.animate(withDuration: duration) {
            alertView.alpha = 0
            
        } completion: { finished in
            alertView.isHidden = true
            alertView.alpha = 1
            
            alertView.removeFromSuperview()
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
    
    func makeMinuteDate(from date: Date) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = .current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        let newDateComponents = DateComponents(year: dateComponents.year!,
                                               month: dateComponents.month!,
                                               day: dateComponents.day!,
                                               hour: dateComponents.hour!,
                                               minute: dateComponents.minute!,
                                               second: 0)
        
        return calendar.date(from: newDateComponents)!
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
        let todayDateComponents = DateComponents(timeZone: TimeZone.current, year: dateComponents.year!, month: dateComponents.month!, day: dateComponents.day!, hour: hour, minute: minute, second: 0)
        
        return calendar.date(from: todayDateComponents)
    }
    
    class func getCurrentTimeSeconds() -> Int {
        return Int(CFAbsoluteTimeGetCurrent())
        
        // MARK: For test
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
    func makeConstraintsOf(_ firstView: UIView, sameAs secondView: UIView) {
        NSLayoutConstraint.activate([
            firstView.topAnchor.constraint(equalTo: secondView.topAnchor),
            firstView.bottomAnchor.constraint(equalTo: secondView.bottomAnchor),
            firstView.leadingAnchor.constraint(equalTo: secondView.leadingAnchor),
            firstView.trailingAnchor.constraint(equalTo: secondView.trailingAnchor)
        ])
    }
    
    // MARK: Control push notification
    func makePushNotificationsWithDateComponents(_ dateComponents: DateComponents,
                                                 repeats: Bool,
                                                 title: String,
                                                 body: String,
                                                 sound: UNNotificationSound,
                                                 identifier: String,
                                                 success: (() -> ())? = nil,
                                                 failure: (() -> ())? = nil) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Adding push identifier(\(identifier)) error: \(error.localizedDescription)")
                
                DispatchQueue.main.async {
                    failure?()
                }
                
            } else {
                print("Succeeded in adding push identifier: \(identifier)")
                
                DispatchQueue.main.async {
                    success?()
                }
            }
        }
    }
    
    func makePushNotificationWithRegion(_ region: CLRegion,
                                        repeats: Bool,
                                        title: String,
                                        body: String,
                                        sound: UNNotificationSound,
                                        identifier: String,
                                        success: (() -> ())? = nil,
                                        failure: (() -> ())? = nil) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNLocationNotificationTrigger(region: region, repeats: repeats)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Adding push identifier(\(identifier)) error: \(error.localizedDescription)")
                
                DispatchQueue.main.async {
                    failure?()
                }
                
            } else {
                print("Succeeded in adding push identifier: \(identifier)")
                
                DispatchQueue.main.async {
                    success?()
                }
            }
        }
    }
    
    private func removePushNotificationForIdentifier(_ identifiers: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        
        for identifier in identifiers {
            print("Remove push identifier: \(identifier)")
        }
    }
    
    func makeStartingWorkTimePush(_ startingWorkTime: Date,
                                  success: (() -> ())? = nil,
                                  failure: (() -> ())? = nil) {
        guard let holidays = ReferenceValues.initialSetting[InitialSetting.regularHolidays.rawValue] as? [Int] else {
            print("Do not add push for starting work time.")
            
            failure?()
            
            return
        }
        
        var workDaysSet: Set<Int> = [1, 2, 3, 4, 5, 6, 7]
        for holiday in holidays {
            workDaysSet.remove(holiday)
        }
        let workDays = Array(workDaysSet)
        
        var calendar = Calendar.current
        calendar.timeZone = .current
        let calendarDateComponents = calendar.dateComponents([.weekday, .hour, .minute, .second], from: startingWorkTime)
        
        for workDay in workDays {
            let identifier =
            workDay == 1 ? ReferenceValues.Identifier.Push.startingWorkTimeOnSun :
            workDay == 2 ? ReferenceValues.Identifier.Push.startingWorkTimeOnMon :
            workDay == 3 ? ReferenceValues.Identifier.Push.startingWorkTimeOnTue :
            workDay == 4 ? ReferenceValues.Identifier.Push.startingWorkTimeOnWed :
            workDay == 5 ? ReferenceValues.Identifier.Push.startingWorkTimeOnThu :
            workDay == 6 ? ReferenceValues.Identifier.Push.startingWorkTimeOnFri :
            ReferenceValues.Identifier.Push.startingWorkTimeOnSat
            
            let dateComponents = DateComponents(hour: calendarDateComponents.hour!, minute: calendarDateComponents.minute!, second: calendarDateComponents.second!, weekday: workDay)
            self.makePushNotificationsWithDateComponents(dateComponents, repeats: true, title: "출근 시간 설정", body: "출근 시간을 설정하세요.", sound: .default, identifier: identifier) {
                success?()
                
            } failure: {
                failure?()
            }
        }
    }
    
    func removeStartingWorkTimePush() {
        self.removePushNotificationForIdentifier([
            ReferenceValues.Identifier.Push.startingWorkTimeOnSun,
            ReferenceValues.Identifier.Push.startingWorkTimeOnMon,
            ReferenceValues.Identifier.Push.startingWorkTimeOnTue,
            ReferenceValues.Identifier.Push.startingWorkTimeOnWed,
            ReferenceValues.Identifier.Push.startingWorkTimeOnThu,
            ReferenceValues.Identifier.Push.startingWorkTimeOnFri,
            ReferenceValues.Identifier.Push.startingWorkTimeOnSat
        ])
    }
    
    func makeTodayFinishingWorkTimePush(_ schedule: WorkScheduleModel?,
                                        success: (() -> ())? = nil,
                                        failure: (() -> ())? = nil) {
        self.removeTodayFinishingWorkTimePush()
        
        guard let finishingWorkTimes = SupportingMethods.shared.useAppSetting(for: .alertFinishingWorkTime) as? [Int], !finishingWorkTimes.isEmpty, let schedule = schedule,
        let regulartime = schedule.finishingRegularWorkTimeSecondsSinceReferenceDate else {
            print("Do not add push for finishing work time.")
            
            failure?()
            
            return
        }
        
        var calendar = Calendar.current
        calendar.timeZone = .current
        let now = Int(Date().timeIntervalSinceReferenceDate)
        
        for finishingWorkTime in finishingWorkTimes {
            let identifier =
            finishingWorkTime == 30 ? ReferenceValues.Identifier.Push.finishingWorkTime30minutes :
            finishingWorkTime == 10 ? ReferenceValues.Identifier.Push.finishingWorkTime10minutes :
            finishingWorkTime == 5 ? ReferenceValues.Identifier.Push.finishingWorkTime5minutes :
            ReferenceValues.Identifier.Push.finishingWorkTimeOclock
            
            if schedule.overtimeSecondsSincReferenceDate > 0 {
                let overtime = schedule.overtimeSecondsSincReferenceDate
                
                if now < overtime - finishingWorkTime * 60 {
                    let date = Date(timeIntervalSinceReferenceDate: Double(overtime - finishingWorkTime * 60))
                    let calendarDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                    
                    self.makePushNotificationsWithDateComponents(calendarDateComponents, repeats: false, title: "업무 종료", body: finishingWorkTime == 0 ? "업무가 종료되었습니다. 자 이제 집으로!" : "업무 종료 \(finishingWorkTime)분 전입니다. 자 이제 곧 집으로!", sound: .default, identifier: identifier) {
                        success?()
                        
                    } failure: {
                        failure?()
                    }
                }
                
            } else {
                if now < regulartime - finishingWorkTime * 60 {
                    let date = Date(timeIntervalSinceReferenceDate: Double(regulartime - finishingWorkTime * 60))
                    let calendarDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                    
                    self.makePushNotificationsWithDateComponents(calendarDateComponents, repeats: false, title: "업무 종료", body: finishingWorkTime == 0 ? "업무가 종료되었습니다. 자 이제 집으로!" : "업무 종료 \(finishingWorkTime)분 전입니다. 자 이제 곧 집으로!", sound: .default, identifier: identifier) {
                        success?()
                        
                    } failure: {
                        failure?()
                    }
                }
            }
        }
    }
    
    func removeTodayFinishingWorkTimePush() {
        self.removePushNotificationForIdentifier([
            ReferenceValues.Identifier.Push.finishingWorkTimeOclock,
            ReferenceValues.Identifier.Push.finishingWorkTime5minutes,
            ReferenceValues.Identifier.Push.finishingWorkTime10minutes,
            ReferenceValues.Identifier.Push.finishingWorkTime30minutes
        ])
    }
    
    func makeCurrentCompanyLocationPush(success: (() -> ())? = nil,
                                        failure: (() -> ())? = nil) {
        let center = CLLocationCoordinate2D(latitude: ReferenceValues.initialSetting[InitialSetting.companyLatitude.rawValue] as! Double, longitude: ReferenceValues.initialSetting[InitialSetting.companyLongitude.rawValue] as! Double)
        let region = CLCircularRegion(center: center, radius: 50, identifier: ReferenceValues.Identifier.Location.companyLocation)
        region.notifyOnEntry = true
        region.notifyOnExit = false
        
        self.makePushNotificationWithRegion(region, repeats: true, title: "회사 근처", body: "회사 근처입니다. 앱을 띄워 스케쥴을 확인하세요.", sound: .default, identifier: ReferenceValues.Identifier.Push.companyLocation) {
            success?()
            
        } failure: {
            failure?()
        }
    }
    
    func removeCurrentCompanyLocationPush() {
        self.removePushNotificationForIdentifier([
            ReferenceValues.Identifier.Push.companyLocation
        ])
    }
    
    func turnOffAndRemoveLocalPush() {
        self.setAppSetting(with: false, for: .pushActivation)
        self.setAppSetting(with: nil, for: .alertSettingStartingWorkTime)
        self.setAppSetting(with: nil, for: .alertFinishingWorkTime)
        self.setAppSetting(with: false, for: .alertCompanyLocation)
        
        self.removeStartingWorkTimePush()
        self.removeTodayFinishingWorkTimePush()
        self.removeCurrentCompanyLocationPush()
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
