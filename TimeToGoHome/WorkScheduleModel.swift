//
//  WorkScheduleModel.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/03/04.
//

import Foundation
import RealmSwift

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
    
    private(set) var dateId: String
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
                guard let finishingRegularWorkTimeSeconds = self.finishingRegularWorkTimeSecondsSinceReferenceDate,
                      let overtime = self.overtime, case .overtime(let overtimeDate) = overtime
                else {
                    return
                }
                
                let overtimeSecondsSincReferenceDate = Int(overtimeDate.timeIntervalSinceReferenceDate)
                self.overtimeSecondsSincReferenceDate = overtimeSecondsSincReferenceDate
                self.overtimeMinutes = (overtimeSecondsSincReferenceDate - finishingRegularWorkTimeSeconds) / 60
            }
        }
    }
    private(set) var overtimeSecondsSincReferenceDate: Int = 0
    private(set) var overtimeMinutes: Int = 0
    
    var isFinishedScheduleToday: Bool = false
    
    var isEditingMode: Bool = false
    
    init(date: Date) {
        // Make today date id
        let dateFormatter = SupportingMethods.shared.makeDateFormatter("yyyyMMdd")
        self.dateId = dateFormatter.string(from: date)
        
        self.scheduling(dateId: self.dateId)
    }
    
    init(dateId: String) {
        self.dateId = dateId
        
        self.scheduling(dateId: dateId)
    }
    
    private mutating func scheduling(dateId: String) {
        // Check DB if there is already today schedule.
        // &&
        // Check tody schedule condition for initial setting.
        self.workType = self.makeWorkType()
        self.startingWorkTime = self.makeStartingWorkTimeDate()
        self.lunchTime = self.makeLunchTimeDate()
        
        let realm = try! Realm()
        let today = SupportingMethods.shared.makeDateFormatter("yyyyMMdd").date(from: dateId)!
        let yearMonthDay = SupportingMethods.shared.getYearMonthAndDayOf(today)
        let company = realm.object(ofType: Company.self, forPrimaryKey: Int(dateId)!)
        let schedules = company?.schedules.where {
            $0.year == String(yearMonthDay.year) &&
            $0.month == String(yearMonthDay.month) &&
            $0.day == String(yearMonthDay.day)
        }
        if let schedule = schedules?.first {
            self.morning = .morning(WorkTimeType(rawValue: schedule.morning)!)
            self.afternoon = .afternoon(WorkTimeType(rawValue: schedule.afternoon)!)
            
            if let overtime = schedule.overtime {
                self.overtime = .overtime(Date(timeIntervalSinceReferenceDate: overtime))
            }
            
            return
        }
        
        let holidays = ReferenceValues.initialSetting[InitialSetting.holidays.rawValue] as! [Int]
        if holidays.contains(SupportingMethods.shared.getWeekdayOfToday(today)) {
            self.morning = .morning(.holiday)
            self.afternoon = .afternoon(.holiday)
            
        } else {
            if let vacation = realm.object(ofType: Vacation.self, forPrimaryKey: Int(dateId)!) {
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
                
                let schedule = Schedule(date: today, morningType: morningWorkTimeType, afternoonType: afternoonWorkTimeType)
                
                // Realm DB
                try! realm.write {
                    company?.schedules.append(schedule)
                }
                
            } else {
                self.morning = .morning(.work)
                self.afternoon = .afternoon(.work)
                
                let schedule = Schedule(date: today, morningType: WorkTimeType.work, afternoonType: WorkTimeType.work)
                
                // Realm DB
                try! realm.write {
                    company?.schedules.append(schedule)
                }
            }
        }
    }
}

// MARK: - Extension for methods added
extension WorkScheduleModel {
    mutating func updateStartingWorkTime(_ startingWorkTimeDate: Date?) {
        SupportingMethods.shared.setAppSetting(with: startingWorkTimeDate, for: .todayStartingTimeDate)
        
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
            if let startingWorkTimeDate = SupportingMethods.shared.useAppSetting(for: .todayStartingTimeDate) as? Date {
                
                var calendar = Calendar.current
                calendar.timeZone = TimeZone.current
                let todayDateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
                let savedStartingWorkTimeDateComponents = calendar.dateComponents([.year, .month, .day], from: startingWorkTimeDate)
                
                if todayDateComponents.year == savedStartingWorkTimeDateComponents.year &&
                    todayDateComponents.month == savedStartingWorkTimeDateComponents.month &&
                    todayDateComponents.day == savedStartingWorkTimeDateComponents.day {
                    
                    return startingWorkTimeDate
                    
                } else {
                    SupportingMethods.shared.setAppSetting(with: nil, for: .todayStartingTimeDate)
                    
                    return nil
                }
                
            } else {
                return nil
            }
            
        case .normal:
            guard let startingWorkTimeValue = ReferenceValues.initialSetting[InitialSetting.morningStartingWorkTimeValue.rawValue] as? Double else {
                return nil
            }
            
            let hour = (Int(startingWorkTimeValue * 10)) / 10
            let minute = Int((Double((Int(startingWorkTimeValue * 10)) % 10) / 10.0) * 60)
            
            var calendar = Calendar.current
            calendar.timeZone = TimeZone.current
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
            let todayDateComponents = DateComponents(timeZone: TimeZone.current, year: dateComponents.year!, month: dateComponents.month!, day: dateComponents.day!, hour: hour, minute: minute)
            
            return calendar.date(from: todayDateComponents)
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
        // Find schedule from DB and update it.
        
        var morning: String = ""
        var afternoon: String = ""
        var overtime: Date?
        
        if case .morning(let morningWorkType) = self.morning, case .afternoon(let afternoonWorkType) = self.afternoon {
            morning = morningWorkType.rawValue
            afternoon = afternoonWorkType.rawValue
        }
        
        if case .overtime(let overtimeDate) = self.overtime {
            overtime = overtimeDate
        }
        
        print("DB - update today")
        print("Today's morning: \(morning)")
        print("Today's afternoon: \(afternoon)")
        overtime != nil ? print("Today's overtime minute: \(overtime!)") : {}()
    }
    
    mutating func refreshToday() {
        // Check DB if there is already today schedule.
        // &&
        // Check tody schedule condition for initial setting.
        self.workType = self.makeWorkType()
        self.startingWorkTime = self.makeStartingWorkTimeDate()
        self.lunchTime = self.makeLunchTimeDate()
        //self.morning = .morning(.work) // FIXME: Temp
        //self.afternoon = .afternoon(.work) // FIXME: Temp
    }
    
    @discardableResult mutating func addSchedule(_ schedule: ScheduleType?) -> Bool {
        guard let schedule = schedule else {
            return false
        }

        switch schedule {
        case .morning(let workType):
            if self.overtime == nil && self.afternoon == nil && self.morning == nil {
                if !self.isEditingMode {
                    print("DB - add workType: \(workType.rawValue)")// FIXME: DB
                }
                self.morning = schedule
                
                return true
                
            } else {
                return false
            }
            
        case .afternoon(let workType):
            if self.overtime == nil && self.afternoon == nil && self.morning != nil {
                if !self.isEditingMode {
                    print("DB - add workType: \(workType.rawValue)")// FIXME: DB
                }
                self.afternoon = schedule
                
                return true
                
            } else {
                return false
            }
            
        case .overtime(let overtime):
            if self.overtime == nil && self.afternoon != nil && self.morning != nil {
                if !self.isEditingMode {
                    print("DB - add overtime: \(overtime)")// FIXME: DB
                }
                self.overtime = schedule
                
                return true
                
            } else {
                return false
            }
        }
    }
    
    @discardableResult mutating func insertSchedule(_ schedule: ScheduleType?) -> Bool {
        guard let schedule = schedule else {
            return false
        }

        switch schedule {
        case .morning(let workType):
            if self.afternoon != nil {
                print("DB - insert workType: \(workType.rawValue)")// FIXME: DB
                self.morning = schedule
                
                return true
                
            } else {
                return false
            }
            
        case .afternoon(let workType):
            if self.morning != nil {
                print("DB - insert workType: \(workType.rawValue)")// FIXME: DB
                self.afternoon = schedule
                
                return true
                
            } else {
                return false
            }
            
        case .overtime(let overtime):
            if self.afternoon != nil && self.morning != nil {
                print("DB - insert overtime: \(overtime)")// FIXME: DB
                self.overtime = schedule
                
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
                if !self.isEditingMode {
                    print("Morning deleted in DB")// FIXME: DB
                }
                self.morning = nil
                
                return true
                
            } else {
                return false
            }
            
        case 2:
            if self.overtime == nil && self.morning != nil && self.afternoon != nil {
                if !self.isEditingMode {
                    print("Afternoon deleted in DB")// FIXME: DB
                }
                self.afternoon = nil
                
                return true
                
            } else {
                return false
            }
            
        case 3:
            if self.morning != nil && self.afternoon != nil && self.overtime != nil {
                if !self.isEditingMode {
                    print("Overtime deleted in DB")// FIXME: DB
                }
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
