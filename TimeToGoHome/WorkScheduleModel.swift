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
                
                return
            }
            
            self.startingWorkTimeSecondsSinceReferenceDate =  Int(startingWorkTime.timeIntervalSinceReferenceDate)
            self.determineFinishingRegularWorkTime()
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
    
    var isTodayScheduleFinished: Bool = {
        if let dateForScheduleFinished = SupportingMethods.shared.useAppSetting(for: .isTodayScheduleFinished) as? Date {
            let yearMonthDayOfScheduleFinished = SupportingMethods.shared.getYearMonthAndDayOf(dateForScheduleFinished)
            let yearMonthDayOfToday = SupportingMethods.shared.getYearMonthAndDayOf(Date())
            
            if yearMonthDayOfScheduleFinished.year == yearMonthDayOfToday.year &&
                yearMonthDayOfScheduleFinished.month == yearMonthDayOfToday.month &&
                yearMonthDayOfScheduleFinished.day == yearMonthDayOfToday.day {
                return true
                
            } else {
                SupportingMethods.shared.setAppSetting(with: nil, for: .isTodayScheduleFinished)
                
                return false
            }
            
        } else {
            return false
        }
        
    }() {
        didSet {
            if self.isTodayScheduleFinished {
                SupportingMethods.shared.setAppSetting(with: Date(), for: .isTodayScheduleFinished)
                
            } else {
                SupportingMethods.shared.setAppSetting(with: nil, for: .isTodayScheduleFinished)
            }
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
    
    private mutating func scheduling() {
        // Check DB if there is already today schedule.
        // &&
        // Check tody schedule condition for initial setting.
        self.workType = self.makeWorkType()
        self.startingWorkTime = self.makeStartingWorkTimeDate()
        self.lunchTime = self.makeLunchTimeDate()
        
        let companyModel = CompanyModel(joiningDate: ReferenceValues.initialSetting[InitialSetting.joiningDate.rawValue] as! Date)
        if let schedule = companyModel.getScheduleOn(self.date) {
            self.morning = .morning(WorkTimeType(rawValue: schedule.morning)!)
            self.afternoon = .afternoon(WorkTimeType(rawValue: schedule.afternoon)!)
            
            if let overtime = schedule.overtime, let finishingRegularWorkTimeSecondsSinceReferenceDate = self.finishingRegularWorkTimeSecondsSinceReferenceDate {
                self.overtime = .overtime(Date(timeIntervalSinceReferenceDate: Double(finishingRegularWorkTimeSecondsSinceReferenceDate + overtime)))
            }
            
            return
        }
        
        let holidays = ReferenceValues.initialSetting[InitialSetting.holidays.rawValue] as! [Int]
        if holidays.contains(SupportingMethods.shared.getWeekdayOfDate(date)) {
            self.morning = .morning(.holiday)
            self.afternoon = .afternoon(.holiday)
            
            let schedule = Schedule(date: date, morningType: WorkTimeType.holiday, afternoonType: WorkTimeType.holiday)
            
            companyModel.addSchedule(schedule)
            
        } else {
            if let vacation = VacationModel(date: date).vacation {
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
                
                let schedule = Schedule(date: date, morningType: morningWorkTimeType, afternoonType: afternoonWorkTimeType)
                
                companyModel.addSchedule(schedule)
                
            } else {
                self.morning = .morning(.work)
                self.afternoon = .afternoon(.work)
                
                let schedule = Schedule(date: date, morningType: WorkTimeType.work, afternoonType: WorkTimeType.work)
                
                companyModel.addSchedule(schedule)
            }
        }
    }
}

// MARK: - Extension for methods added
extension WorkScheduleModel {
    mutating func updateStartingWorkTime(_ startingWorkTimeDate: Date?) {
        if self.workType == .staggered {
            SupportingMethods.shared.setAppSetting(with: startingWorkTimeDate, for: .timeDateForStartingTodaySchedule)
        }
        
        self.refreshToday()
    }
    
    mutating func makeWorkType() -> WorkType? {
        guard let workTypeString = ReferenceValues.initialSetting[InitialSetting.workType.rawValue] as? String else {
            return nil
        }
        
        if workTypeString == WorkType.staggered.rawValue {
            return .staggered
            
        } else {
            return .normal
        }
    }
    
    mutating func makeStartingWorkTimeDate() -> Date? {
        guard let workType = self.workType else {
            return nil
        }
        
        switch workType {
        case .staggered:
            if let timeDateForStartingTodaySchedule = SupportingMethods.shared.useAppSetting(for: .timeDateForStartingTodaySchedule) as? Date {
                
                let yearMonthDayOfToday = SupportingMethods.shared.getYearMonthAndDayOf(Date())
                let yearMonthDayOfStartingTodaySchedule = SupportingMethods.shared.getYearMonthAndDayOf(timeDateForStartingTodaySchedule)
                
                
                if yearMonthDayOfToday.year == yearMonthDayOfStartingTodaySchedule.year &&
                    yearMonthDayOfToday.month == yearMonthDayOfStartingTodaySchedule.month &&
                    yearMonthDayOfToday.day == yearMonthDayOfStartingTodaySchedule.day {
                    
                    return timeDateForStartingTodaySchedule
                    
                } else {
                    SupportingMethods.shared.setAppSetting(with: nil, for: .timeDateForStartingTodaySchedule)
                    
                    return nil
                }
                
            } else {
                return nil
            }
            
        case .normal:
            var calendar = Calendar.current
            calendar.timeZone = TimeZone.current
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
            
            if case .morning(let workType) = self.morning, case .work = workType,
                case .afternoon(let workType) = self.afternoon, case .work = workType {
                guard let startingWorkTimeValue = ReferenceValues.initialSetting[InitialSetting.morningStartingWorkTimeValue.rawValue] as? Double else {
                    return nil
                }
                
                let hour = (Int(startingWorkTimeValue * 10)) / 10
                let minute = Int((Double((Int(startingWorkTimeValue * 10)) % 10) / 10.0) * 60)
                
                let todayDateComponents = DateComponents(timeZone: TimeZone.current, year: dateComponents.year!, month: dateComponents.month!, day: dateComponents.day!, hour: hour, minute: minute)
                
                return calendar.date(from: todayDateComponents)
                
            } else if case .morning(let workType) = self.morning, case .work = workType {
                guard let startingWorkTimeValue = ReferenceValues.initialSetting[InitialSetting.morningStartingWorkTimeValue.rawValue] as? Double else {
                    return nil
                }
                
                let hour = (Int(startingWorkTimeValue * 10)) / 10
                let minute = Int((Double((Int(startingWorkTimeValue * 10)) % 10) / 10.0) * 60)
                
                let todayDateComponents = DateComponents(timeZone: TimeZone.current, year: dateComponents.year!, month: dateComponents.month!, day: dateComponents.day!, hour: hour, minute: minute)
                
                return calendar.date(from: todayDateComponents)
                
            } else if case .afternoon(let workType) = self.afternoon, case .work = workType {
                guard let startingWorkTimeValue = ReferenceValues.initialSetting[InitialSetting.afternoonStartingworkTimeValue.rawValue] as? Double else {
                    return nil
                }
                
                let hour = (Int(startingWorkTimeValue * 10)) / 10
                let minute = Int((Double((Int(startingWorkTimeValue * 10)) % 10) / 10.0) * 60)
                
                let todayDateComponents = DateComponents(timeZone: TimeZone.current, year: dateComponents.year!, month: dateComponents.month!, day: dateComponents.day!, hour: hour, minute: minute)
                
                return calendar.date(from: todayDateComponents)
                
            } else {
                return nil
            }
        }
    }
    
    mutating func makeLunchTimeDate() -> Date! {
        guard let lunchTimeValue = ReferenceValues.initialSetting[InitialSetting.lunchTimeValue.rawValue] as? Double else {
            return nil
        }
        
        let hour = (Int(lunchTimeValue * 10)) / 10
        let minute = Int((Double((Int(lunchTimeValue * 10)) % 10) / 10.0) * 60)
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        let todayDateComponents = DateComponents(timeZone: TimeZone.current, year: dateComponents.year!, month: dateComponents.month!, day: dateComponents.day!, hour: hour, minute: minute)
        
        return calendar.date(from: todayDateComponents)
    }
    
    func updateTodayIntoDB() {
        if case .morning(let morningWorkType) = self.morning, case .afternoon(let afternoonWorkType) = self.afternoon {
            let schedule = Schedule(date: self.date, morningType: morningWorkType, afternoonType: afternoonWorkType)
            if case .overtime(_) = self.overtime {
                let overtime = self.overtimeSecondsSincReferenceDate - self.finishingRegularWorkTimeSecondsSinceReferenceDate!
                schedule.overtime = overtime
            }
            CompanyModel(joiningDate: ReferenceValues.initialSetting[InitialSetting.joiningDate.rawValue] as! Date).setSchedule(schedule)
            
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
    
    mutating func refreshToday() { // FIXME: Refresh today for setting change.
        // Check DB if there is already today schedule.
        // &&
        // Check tody schedule condition for initial setting.
        self.workType = self.makeWorkType()
        self.startingWorkTime = self.makeStartingWorkTimeDate()
        self.lunchTime = self.makeLunchTimeDate()
        //self.morning = .morning(.work) // FIXME: Temp
        //self.afternoon = .afternoon(.work) // FIXME: Temp
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
        
        let isIgnoredLunchTimeForHalfVacation = ReferenceValues.initialSetting[InitialSetting.isIgnoredLunchTimeForHalfVacation.rawValue] as! Bool
        
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
