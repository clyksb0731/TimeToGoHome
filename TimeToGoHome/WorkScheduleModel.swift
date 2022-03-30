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
    
    static let today: WorkScheduleModel = WorkScheduleModel(date: Date())
    
    private(set) var dateId: String
    private(set) var workType: WorkType?
    private(set) var startingWorkTime: Date? = nil {
        willSet {
            guard let startingWorkTime = newValue else {
                return
            }
            
            self.startingWorkTimeSecondsSinceReferenceDate =  Int(startingWorkTime.timeIntervalSinceReferenceDate)
        }
    }
    private(set) var startingWorkTimeSecondsSinceReferenceDate: Int?
    private(set) var lunchTime: Date? = nil {
        willSet {
            guard let lunchTime = newValue else {
                return
            }
            
            self.lunchTimeSecondsSinceReferenceDate = Int(lunchTime.timeIntervalSinceReferenceDate)
        }
    }
    private(set) var lunchTimeSecondsSinceReferenceDate: Int?
    private(set) var morning: ScheduleType? = nil {
        willSet {
            guard let startingWorkTimeSeconds = self.startingWorkTimeSecondsSinceReferenceDate else {
                return
            }
            
            if case .morning(let workType) = newValue, case .work = workType,
               case .afternoon(let workType) = self.afternoon, case .work = workType {
                self.finishingRegularWorkTimeSecondsSinceReferenceDate = startingWorkTimeSeconds + type(of: self).secondsOfWorkTime + type(of: self).secondsOfLunchTime + type(of: self).secondsOfWorkTime
                
            } else if case .morning(let workType) = newValue, case .work = workType {
                self.finishingRegularWorkTimeSecondsSinceReferenceDate = startingWorkTimeSeconds + type(of: self).secondsOfWorkTime
                
            } else if case .afternoon(let workType) = self.afternoon, case .work = workType {
                self.finishingRegularWorkTimeSecondsSinceReferenceDate = startingWorkTimeSeconds + type(of: self).secondsOfWorkTime
                
            } else {
                self.finishingRegularWorkTimeSecondsSinceReferenceDate = nil
            }
        }
    }
    private(set) var afternoon: ScheduleType? = nil {
        willSet {
            guard let startingWorkTimeSeconds = self.startingWorkTimeSecondsSinceReferenceDate else {
                return
            }
            
            if case .morning(let workType) = self.morning, case .work = workType,
               case .afternoon(let workType) = newValue, case .work = workType {
                self.finishingRegularWorkTimeSecondsSinceReferenceDate = startingWorkTimeSeconds + type(of: self).secondsOfWorkTime + type(of: self).secondsOfLunchTime + type(of: self).secondsOfWorkTime
                
            } else if case .morning(let workType) = self.morning, case .work = workType {
                self.finishingRegularWorkTimeSecondsSinceReferenceDate = startingWorkTimeSeconds + type(of: self).secondsOfWorkTime
                
            } else if case .afternoon(let workType) = newValue, case .work = workType {
                self.finishingRegularWorkTimeSecondsSinceReferenceDate = startingWorkTimeSeconds + type(of: self).secondsOfWorkTime
                
            } else {
                self.finishingRegularWorkTimeSecondsSinceReferenceDate = nil
            }
        }
    }
    private(set) var finishingRegularWorkTimeSecondsSinceReferenceDate: Int?
    private(set) var overtime: ScheduleType? = nil {
        willSet {
            guard let finishingRegularWorkTimeSeconds = self.finishingRegularWorkTimeSecondsSinceReferenceDate,
                  let overtime = newValue, case .overtime(let overtimeDate) = overtime
            else {
                return
            }
            
            self.overtimeMinutes = (Int(overtimeDate.timeIntervalSinceReferenceDate) - finishingRegularWorkTimeSeconds) / 60
        }
    }
    private(set) var overtimeMinutes: Int?
    
    var isFinishedScheduleToday: Bool = false
    
    var isEditingMode: Bool = false
    
    init(date: Date) {
        // Make today date id
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyyMMdd"
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
        self.workType = self.makeWorkType() // FIXME: From app setting
        self.startingWorkTime = self.makeStartingWorkTimeDate()
        self.lunchTime = self.makeLunchTimeDate()
        self.morning = .morning(.work) // FIXME: Temp
        self.afternoon = .afternoon(.work) // FIXME: Temp
        //self.overtime = .overtime(Date()) // FIXME: Temp
    }
}

// MARK: - Extension for methods added
extension WorkScheduleModel {
    mutating func updateStartingWorkTime(_ startingWorkTimeDate: Date) {
        SupportingMethods.shared.setAppSetting(with: startingWorkTimeDate, for: .startingWorkTimeValue)
        self.startingWorkTime = startingWorkTimeDate
        
        self.refreshToday()
    }
    
    mutating func makeWorkType() -> WorkType? {
        guard let workTypeString = SupportingMethods.shared.useAppSetting(for: .workType) as? String else {
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
            if let startingWorkTimeDate = SupportingMethods.shared.useAppSetting(for: .startingWorkTimeValue) as? Date {
                
                var calendar = Calendar.current
                calendar.timeZone = TimeZone.current
                let todayDateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
                let savedStartingWorkTimeDateComponents = calendar.dateComponents([.year, .month, .day], from: startingWorkTimeDate)
                
                if todayDateComponents.year == savedStartingWorkTimeDateComponents.year &&
                    todayDateComponents.month == savedStartingWorkTimeDateComponents.month &&
                    todayDateComponents.day == savedStartingWorkTimeDateComponents.day {
                    
                    return startingWorkTimeDate
                    
                } else {
                    SupportingMethods.shared.setAppSetting(with: nil, for: .startingWorkTimeValue)
                    
                    return nil
                }
                
            } else {
                return nil
            }
            
        case .normal:
            guard let startingWorkTimeValue = SupportingMethods.shared.useAppSetting(for: .startingWorkTimeValue) as? Double else {
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
    
    mutating func makeLunchTimeDate() -> Date? {
        guard let lunchTimeValue = SupportingMethods.shared.useAppSetting(for: .lunchTimeValue) as? Double else {
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
        self.morning = .morning(.work) // FIXME: Temp
        self.afternoon = .afternoon(.work) // FIXME: Temp
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
