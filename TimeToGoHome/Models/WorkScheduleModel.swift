//
//  WorkScheduleModel.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/03/04.
//

import Foundation

enum WorkTimeType: String {
    case work = "work"
    case vacation = "vacation"
    case holiday = "holiday"
}

enum ScheduleType {
    case morning(WorkTimeType)
    case afternoon(WorkTimeType)
    case overtime(Date)
}

struct WorkScheduleModel {
    static let secondsOfLunchTime: Int = 3600
    static let secondsOfWorkTime: Int = 3600 * 4
    
    var count: Int {
        if self.overtime != nil {
            return 3
            
        } else if self.afternoon != nil {
            return 2
            
        } else if self.morning != nil {
            return 1
            
        } else {
            return 0
        }
    }
    
    var isAvailableToWork: Bool {
        if case .morning(let morningWorkType) = self.morning, case .afternoon(let afternoonWorkType) = self.afternoon {
            if morningWorkType == .work || afternoonWorkType == .work {
                return true
                
            } else {
                return false
            }
            
        } else {
            return false
        }
    }
    
    static var today: WorkScheduleModel {
        return WorkScheduleModel(date: Date())
    }
    
    private(set) var date: Date
    private(set) var workType: WorkType?
    private(set) var startingWorkTime: Date? {
        didSet {
            guard let startingWorkTime = self.startingWorkTime else {
                self.startingWorkTimeSecondsSinceReferenceDate = nil
                self.determineFinishingRegularWorkTime()
                
                // To remove finishing work time push
                SupportingMethods.shared.determineTodayFinishingWorkTimePush(self)
                
                return
            }
            
            self.startingWorkTimeSecondsSinceReferenceDate =  Int(startingWorkTime.timeIntervalSinceReferenceDate)
            self.determineFinishingRegularWorkTime()
            
            // After setting starting work time.
            SupportingMethods.shared.determineTodayFinishingWorkTimePush(self)
        }
    }
    private(set) var startingWorkTimeSecondsSinceReferenceDate: Int?
    private(set) var lunchTime: Date! {
        didSet {
            self.lunchTimeSecondsSinceReferenceDate = Int(lunchTime.timeIntervalSinceReferenceDate)
        }
    }
    private(set) var lunchTimeSecondsSinceReferenceDate: Int = 0
    private(set) var morning: ScheduleType? {
        didSet {
            self.determineFinishingRegularWorkTime()
        }
    }
    private(set) var afternoon: ScheduleType? {
        didSet {
            self.determineFinishingRegularWorkTime()
        }
    }
    private(set) var finishingRegularWorkTimeSecondsSinceReferenceDate: Int?
    private(set) var overtime: ScheduleType? {
        didSet {
            if self.overtime == nil {
                self.overtimeSecondsSincReferenceDate = 0
                
                //self.determineFinishingRegularWorkTime()
                
            } else {
                guard let _ = self.finishingRegularWorkTimeSecondsSinceReferenceDate,
                      let overtime = self.overtime, case .overtime(let overtimeDate) = overtime
                else {
                    return
                }
                
                self.overtimeSecondsSincReferenceDate = Int(overtimeDate.timeIntervalSinceReferenceDate)
            }
        }
    }
    private(set) var overtimeSecondsSincReferenceDate: Int = 0
    
    var dateOfFinishedSchedule: Date? = {
        if let dateOfFinishedSchedule = SupportingMethods.shared.useAppSetting(for: .dateForFinishedSchedule) as? Date {
            let yearMonthDayOfScheduleFinished = SupportingMethods.shared.getYearMonthAndDayOf(dateOfFinishedSchedule)
            let yearMonthDayOfToday = SupportingMethods.shared.getYearMonthAndDayOf(Date())
            
            if yearMonthDayOfScheduleFinished.year == yearMonthDayOfToday.year &&
                yearMonthDayOfScheduleFinished.month == yearMonthDayOfToday.month &&
                yearMonthDayOfScheduleFinished.day == yearMonthDayOfToday.day {
                return dateOfFinishedSchedule
                
            } else {
                SupportingMethods.shared.setAppSetting(with: nil, for: .dateForFinishedSchedule)
                
                return nil
            }
            
        } else {
            return nil
        }
        
    }() {
        didSet {
            if let date = self.dateOfFinishedSchedule {
                SupportingMethods.shared.setAppSetting(with: date, for: .dateForFinishedSchedule)
                
            } else {
                SupportingMethods.shared.setAppSetting(with: nil, for: .dateForFinishedSchedule)
            }
        }
    }
    
    var isIgnoringLunchTime: Bool = {
        let dateId = SupportingMethods.shared.makeDateFormatter("yyyyMMdd").string(from: Date())
        if let ignoreLunchTimeValue = SupportingMethods.shared.useAppSetting(for: .isIgnoredLunchTimeToday) as? [String:Bool], let isIgnoredLunchTime = ignoreLunchTimeValue[dateId] {
            return isIgnoredLunchTime
            
        } else {
            if let workType = ReferenceValues.initialSetting[InitialSetting.workType.rawValue] as? String, workType == WorkType.staggered.rawValue {
                return ReferenceValues.initialSetting[InitialSetting.isIgnoredLunchTimeOfStaggeredWorkType.rawValue] as? Bool == true
            } else {
                return ReferenceValues.initialSetting[InitialSetting.isIgnoredLunchTimeOfNormalWorkType.rawValue] as? Bool == true
            }
        }
    }() {
        didSet {
            let dateId = SupportingMethods.shared.makeDateFormatter("yyyyMMdd").string(from: Date())
            SupportingMethods.shared.setAppSetting(with: [dateId:self.isIgnoringLunchTime], for: .isIgnoredLunchTimeToday)
            
            self.determineFinishingRegularWorkTime()
        }
    }
    
    var isEditingMode: Bool = false
    
    init(date: Date) {
        self.date = date
        
        self.scheduling()
    }
    
    init(dateId: String) {
        let date = SupportingMethods.shared.makeDateFormatter("yyyyMMdd").date(from: dateId)!
        self.date = date
        
        self.scheduling()
    }
}

// MARK: - Extension for methods added
extension WorkScheduleModel {
    private mutating func scheduling() {
        // Check DB if there is already today schedule.
        // &&
        // Check tody schedule condition for initial setting.
        self.determineWorkType()
        self.determineLunchTimeDate()
        self.determineStartingWorkTimeDate()
        
        let todayDateId = Int(SupportingMethods.shared.makeDateFormatter("yyyyMMdd").string(from: self.date))!
        if let leavingDate = ReferenceValues.initialSetting[InitialSetting.leavingDate.rawValue] as? Date,
            let leavingDateId = Int(SupportingMethods.shared.makeDateFormatter("yyyyMMdd").string(from: leavingDate)),
            todayDateId > leavingDateId {
            self.morning = .morning(.holiday)
            self.afternoon = .afternoon(.holiday)
            
        } else {
            let companyModel = CompanyModel(joiningDate: ReferenceValues.initialSetting[InitialSetting.joiningDate.rawValue] as! Date)
            if let schedule = companyModel.getScheduleOn(self.date) {
                self.morning = .morning(WorkTimeType(rawValue: schedule.morning)!)
                self.afternoon = .afternoon(WorkTimeType(rawValue: schedule.afternoon)!)
                
                if let overtime = schedule.overtime, let finishingRegularWorkTimeSecondsSinceReferenceDate = self.finishingRegularWorkTimeSecondsSinceReferenceDate {
                    self.overtime = .overtime(Date(timeIntervalSinceReferenceDate: Double(finishingRegularWorkTimeSecondsSinceReferenceDate + overtime)))
                }
                
            } else {
                let holidays = ReferenceValues.initialSetting[InitialSetting.regularHolidays.rawValue] as! [Int]
                if holidays.contains(SupportingMethods.shared.getWeekdayOfDate(self.date)) || PublicHolidayModel.publicHolidays.contains(where: { $0.dateId == Int(SupportingMethods.shared.makeDateFormatter("yyyyMMdd").string(from: self.date)) }) {
                    self.morning = .morning(.holiday)
                    self.afternoon = .afternoon(.holiday)
                    
                    // No need to make schedule onto DB because it is regular holiday. So this code was removed.
                    //let schedule = Schedule(date: self.date, morningType: WorkTimeType.holiday, afternoonType: WorkTimeType.holiday)
                    //companyModel.applySchedule(schedule)
                    
                } else {
                    if let vacation = VacationModel(date: self.date).vacation {
                        let vacationType = VacationType(rawValue: vacation.vacationType)!
                        
                        var morningWorkTimeType: WorkTimeType!
                        var afternoonWorkTimeType: WorkTimeType!
                        
                        switch vacationType {
                        case .none:
                            self.morning = .morning(.work)
                            self.afternoon = .afternoon(.work)
                            
                            morningWorkTimeType = WorkTimeType.work
                            afternoonWorkTimeType = WorkTimeType.work
                            
                        case .morning:
                            self.morning = .morning(.vacation)
                            self.afternoon = .afternoon(.work)
                            
                            morningWorkTimeType = WorkTimeType.vacation
                            afternoonWorkTimeType = WorkTimeType.work
                            
                        case .afternoon:
                            self.morning = .morning(.work)
                            self.afternoon = .afternoon(.vacation)
                            
                            morningWorkTimeType = WorkTimeType.work
                            afternoonWorkTimeType = WorkTimeType.vacation
                            
                        case .fullDay:
                            self.morning = .morning(.vacation)
                            self.afternoon = .afternoon(.vacation)
                            
                            morningWorkTimeType = WorkTimeType.vacation
                            afternoonWorkTimeType = WorkTimeType.vacation
                        }
                        
                        let schedule = Schedule(date: self.date, morningType: morningWorkTimeType, afternoonType: afternoonWorkTimeType)
                        
                        companyModel.applySchedule(schedule)
                        
                    } else {
                        self.morning = .morning(.work)
                        self.afternoon = .afternoon(.work)
                        
                        let schedule = Schedule(date: self.date, morningType: WorkTimeType.work, afternoonType: WorkTimeType.work)
                        
                        companyModel.applySchedule(schedule)
                    }
                }
                
                self.determineStartingWorkTimeDate() // For Determining starting work time when schedule isn't in DB or after leaving date
            }
        }
    }
    
    mutating func refreshToday() {
        self.determineWorkType()
        self.determineLunchTimeDate()
        self.determineStartingWorkTimeDate()
    }
    
    mutating func updateStartingWorkTime(_ startingWorkTimeDate: Date? = nil) {
        if self.workType == .staggered {
            SupportingMethods.shared.setAppSetting(with: startingWorkTimeDate, for: .timeDateForStartingTodayOfStaggeredSchedule)
        }
        
        self.determineStartingWorkTimeDate()
    }
    
    mutating func determineWorkType() {
        guard let workTypeString = ReferenceValues.initialSetting[InitialSetting.workType.rawValue] as? String else {
            return
        }
        
        if workTypeString == WorkType.staggered.rawValue {
            self.workType = .staggered
            
        } else {
            self.workType = .normal
        }
    }
    
    mutating func determineStartingWorkTimeDate() {
        guard let workType = self.workType else {
            return
        }
        
        let todayDateId = Int(SupportingMethods.shared.makeDateFormatter("yyyyMMdd").string(from: self.date))!
        if let leavingDate = ReferenceValues.initialSetting[InitialSetting.leavingDate.rawValue] as? Date,
            let leavingDateId = Int(SupportingMethods.shared.makeDateFormatter("yyyyMMdd").string(from: leavingDate)),
           todayDateId > leavingDateId {
            SupportingMethods.shared.setAppSetting(with: nil, for: .timeDateForStartingTodayOfStaggeredSchedule)
            
            self.startingWorkTime = nil
            
            return
        }
        
        switch workType {
        case .staggered:
            if let timeDateForStartingTodaySchedule = SupportingMethods.shared.useAppSetting(for: .timeDateForStartingTodayOfStaggeredSchedule) as? Date {
                let yearMonthDayOfToday = SupportingMethods.shared.getYearMonthAndDayOf(self.date)
                let yearMonthDayOfStartingTodaySchedule = SupportingMethods.shared.getYearMonthAndDayOf(timeDateForStartingTodaySchedule)
                
                if yearMonthDayOfToday.year == yearMonthDayOfStartingTodaySchedule.year &&
                    yearMonthDayOfToday.month == yearMonthDayOfStartingTodaySchedule.month &&
                    yearMonthDayOfToday.day == yearMonthDayOfStartingTodaySchedule.day {
                    
                    self.startingWorkTime = timeDateForStartingTodaySchedule
                    
                } else {
                    SupportingMethods.shared.setAppSetting(with: nil, for: .timeDateForStartingTodayOfStaggeredSchedule)
                    
                    self.startingWorkTime = nil
                }
                
            } else {
                self.startingWorkTime = nil
            }
            
        case .normal:
            var calendar = Calendar.current
            calendar.timeZone = TimeZone.current
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: self.date)
            
            let companyModel = CompanyModel(joiningDate: ReferenceValues.initialSetting[InitialSetting.joiningDate.rawValue] as! Date)
            if let schedule = companyModel.getScheduleOn(self.date) {
                if schedule.morning == WorkTimeType.work.rawValue,
                   schedule.afternoon == WorkTimeType.work.rawValue {
                    guard let startingWorkTimeValue = ReferenceValues.initialSetting[InitialSetting.morningStartingWorkTimeValue.rawValue] as? Double else {
                        return
                    }
                    
                    let hour = (Int(startingWorkTimeValue * 10)) / 10
                    let minute = Int((Double((Int(startingWorkTimeValue * 10)) % 10) / 10.0) * 60)
                    
                    let todayDateComponents = DateComponents(timeZone: TimeZone.current, year: dateComponents.year!, month: dateComponents.month!, day: dateComponents.day!, hour: hour, minute: minute)
                    
                    self.startingWorkTime = calendar.date(from: todayDateComponents)
                    
                } else if schedule.morning == WorkTimeType.work.rawValue {
                    guard let startingWorkTimeValue = ReferenceValues.initialSetting[InitialSetting.morningStartingWorkTimeValue.rawValue] as? Double else {
                        return
                    }
                    
                    let hour = (Int(startingWorkTimeValue * 10)) / 10
                    let minute = Int((Double((Int(startingWorkTimeValue * 10)) % 10) / 10.0) * 60)
                    
                    let todayDateComponents = DateComponents(timeZone: TimeZone.current, year: dateComponents.year!, month: dateComponents.month!, day: dateComponents.day!, hour: hour, minute: minute)
                    
                    self.startingWorkTime = calendar.date(from: todayDateComponents)
                    
                } else if schedule.afternoon == WorkTimeType.work.rawValue {
                    guard let startingWorkTimeValue = ReferenceValues.initialSetting[InitialSetting.afternoonStartingWorkTimeValue.rawValue] as? Double else {
                        return
                    }
                    
                    let hour = (Int(startingWorkTimeValue * 10)) / 10
                    let minute = Int((Double((Int(startingWorkTimeValue * 10)) % 10) / 10.0) * 60)
                    
                    let todayDateComponents = DateComponents(timeZone: TimeZone.current, year: dateComponents.year!, month: dateComponents.month!, day: dateComponents.day!, hour: hour, minute: minute)
                    
                    self.startingWorkTime = calendar.date(from: todayDateComponents)
                    
                } else {
                    self.startingWorkTime = nil
                }
                
            } else {
                self.startingWorkTime = nil
            }
        }
    }
    
    mutating func determineLunchTimeDate() {
        guard let lunchTimeValue = ReferenceValues.initialSetting[InitialSetting.lunchTimeValue.rawValue] as? Double else {
            return
        }
        
        let hour = (Int(lunchTimeValue * 10)) / 10
        let minute = Int((Double((Int(lunchTimeValue * 10)) % 10) / 10.0) * 60)
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: self.date)
        let todayDateComponents = DateComponents(timeZone: TimeZone.current, year: dateComponents.year!, month: dateComponents.month!, day: dateComponents.day!, hour: hour, minute: minute)
        
        self.lunchTime = calendar.date(from: todayDateComponents)
    }
    
    func updateTodayIntoDB(_ isRequiredDeterminingFinishingWorkTimePush: Bool) {
        let companyModel = CompanyModel(joiningDate: ReferenceValues.initialSetting[InitialSetting.joiningDate.rawValue] as! Date)
        if case .morning(let morningWorkType) = self.morning, case .afternoon(let afternoonWorkType) = self.afternoon {
            let schedule = Schedule(date: self.date, morningType: morningWorkType, afternoonType: afternoonWorkType)
            if case .overtime(_) = self.overtime {
                let overtime = self.overtimeSecondsSincReferenceDate - self.finishingRegularWorkTimeSecondsSinceReferenceDate!
                schedule.overtime = overtime
            }
            
            companyModel.applySchedule(schedule)
            
            if isRequiredDeterminingFinishingWorkTimePush {
                SupportingMethods.shared.determineTodayFinishingWorkTimePush(self)
            }
            
            var vacation: Vacation!
            if morningWorkType == .vacation && afternoonWorkType == .vacation {
                vacation = Vacation(date: self.date, vacationType: .fullDay)
                
            } else if morningWorkType == .vacation {
                vacation = Vacation(date: self.date, vacationType: .morning)
                
            } else if afternoonWorkType == .vacation {
                vacation = Vacation(date: self.date, vacationType: .afternoon)
                
            } else {
                vacation = Vacation(date: self.date, vacationType: .none)
            }
            VacationModel.addVacation(vacation)
            
            print("DB - update today")
            print("Today's morning: \(schedule.morning)")
            print("Today's afternoon: \(schedule.afternoon)")
            print("Today's overtime: \(schedule.overtime ?? 0)")
        }
    }
    
    @discardableResult mutating func addSchedule(_ addingSchedule: ScheduleType?) -> Bool {
        guard let addingSchedule = addingSchedule else {
            return false
        }

        switch addingSchedule {
        case .morning(_):
            if self.overtime == nil && self.afternoon == nil && self.morning == nil {
                self.morning = addingSchedule
                
                return true
                
            } else {
                return false
            }
            
        case .afternoon(_):
            if self.overtime == nil && self.afternoon == nil && self.morning != nil {
                self.afternoon = addingSchedule
                
                return true
                
            } else {
                return false
            }
            
        case .overtime(_):
            if self.overtime == nil && self.afternoon != nil && self.morning != nil {
                self.overtime = addingSchedule
                
                return true
                
            } else {
                return false
            }
        }
    }
    
    @discardableResult mutating func insertSchedule(_ insertingSchedule: ScheduleType?) -> Bool {
        guard let insertingSchedule = insertingSchedule else {
            return false
        }

        switch insertingSchedule {
        case .morning(_):
            if self.afternoon != nil {
                self.morning = insertingSchedule
                
                return true
                
            } else {
                return false
            }
            
        case .afternoon(_):
            if self.morning != nil {
                self.afternoon = insertingSchedule
                
                return true
                
            } else {
                return false
            }
            
        case .overtime(_):
            if self.afternoon != nil && self.morning != nil {
                self.overtime = insertingSchedule
                
                return true
                
            } else {
                return false
            }
        }
    }
    
    @discardableResult mutating func removeSchedule(_ scheduleOrder: Int) -> Bool {
        switch scheduleOrder {
        case 1:
            if self.overtime == nil && self.afternoon == nil && self.morning != nil {
                self.morning = nil
                
                return true
                
            } else {
                return false
            }
            
        case 2:
            if self.overtime == nil && self.morning != nil && self.afternoon != nil {
                self.afternoon = nil
                
                return true
                
            } else {
                return false
            }
            
        case 3:
            if self.morning != nil && self.afternoon != nil && self.overtime != nil {
                self.overtime = nil
                
                return true
                
            } else {
                return false
            }
            
        default:
            return false
        }
    }
    
    func scheduleForOrder(_ order: Int) -> ScheduleType? {
        if (order == 1) {
            return self.morning
        }
        
        if (order == 2) {
            return self.afternoon
        }
        
        if (order == 3) {
            return self.overtime
        }
        
        return nil
    }
    
    mutating func determineFinishingRegularWorkTime() {
        guard let startingWorkTimeSeconds = self.startingWorkTimeSecondsSinceReferenceDate else {
            self.finishingRegularWorkTimeSecondsSinceReferenceDate = nil
            
            return
        }
        
        let isIgnoredLunchTimeForHalfVacation = self.isIgnoringLunchTime
        
        if case .morning(let workType) = self.morning, case .work = workType,
           case .afternoon(let workType) = self.afternoon, case .work = workType {
            self.finishingRegularWorkTimeSecondsSinceReferenceDate = startingWorkTimeSeconds + type(of: self).secondsOfWorkTime + type(of: self).secondsOfLunchTime + type(of: self).secondsOfWorkTime
            
        } else if case .morning(let workType) = self.morning, case .work = workType {
            if isIgnoredLunchTimeForHalfVacation {
                self.finishingRegularWorkTimeSecondsSinceReferenceDate = startingWorkTimeSeconds + type(of: self).secondsOfWorkTime
                
            } else {
                if self.lunchTimeSecondsSinceReferenceDate >= startingWorkTimeSeconds + type(of: self).secondsOfWorkTime {
                    self.finishingRegularWorkTimeSecondsSinceReferenceDate = startingWorkTimeSeconds + type(of: self).secondsOfWorkTime
                    
                } else { // self.lunchTimeSecondsSinceReferenceDate < startingWorkTimeSeconds + type(of: self).secondsOfWorkTime
                    self.finishingRegularWorkTimeSecondsSinceReferenceDate = startingWorkTimeSeconds + type(of: self).secondsOfLunchTime + type(of: self).secondsOfWorkTime
                }
            }
            
        } else if case .afternoon(let workType) = self.afternoon, case .work = workType {
            if isIgnoredLunchTimeForHalfVacation {
                self.finishingRegularWorkTimeSecondsSinceReferenceDate = startingWorkTimeSeconds + type(of: self).secondsOfWorkTime
                
            } else {
                if startingWorkTimeSeconds >= self.lunchTimeSecondsSinceReferenceDate + type(of:self).secondsOfLunchTime {
                    self.finishingRegularWorkTimeSecondsSinceReferenceDate = startingWorkTimeSeconds + type(of: self).secondsOfWorkTime
                    
                } else if startingWorkTimeSeconds >= self.lunchTimeSecondsSinceReferenceDate &&
                            startingWorkTimeSeconds < self.lunchTimeSecondsSinceReferenceDate + type(of: self).secondsOfLunchTime {
                    self.finishingRegularWorkTimeSecondsSinceReferenceDate = self.lunchTimeSecondsSinceReferenceDate + type(of: self).secondsOfLunchTime + type(of: self).secondsOfWorkTime
                    
                } else { // startingWorkTimeSeconds < self.lunchTimeSecondsSinceReferenceDate
                    self.finishingRegularWorkTimeSecondsSinceReferenceDate = startingWorkTimeSeconds + type(of: self).secondsOfLunchTime + type(of: self).secondsOfWorkTime
                }
            }
            
        } else {
            self.finishingRegularWorkTimeSecondsSinceReferenceDate = nil
        }
    }
}

// MARK: - Extension for static methods added
extension WorkScheduleModel {
    static func makeNewScheduleBasedOnCountOfSchedule(_ schedule: WorkScheduleModel, with associatedValue: Any) -> ScheduleType? {
        if schedule.count == 0 {
            if let workType = associatedValue as? WorkTimeType {
                return .morning(workType)
            }
            
            return nil
            
        } else if schedule.count == 1 {
            if let workType = associatedValue as? WorkTimeType {
                return .afternoon(workType)
            }
            
            return nil
            
        } else if schedule.count == 2 {
            if let overtime = associatedValue as? Date {
                return .overtime(overtime)
            }
            
            return nil
            
        } else { // 3
            return nil
        }
    }
}
