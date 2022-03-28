//
//  WorkScheduleModel.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/03/04.
//

import Foundation

enum WorkType: String {
    case work = "work"
    case vacation = "vacation"
    case holiday = "holiday"
}

enum ScheduleType {
    case morning(WorkType)
    case afternoon(WorkType)
    case overtime(Date)
}

struct WorkSchedule {
    static let secondsOfOneHour: Int = 3600
    static let secondsOfFourHours: Int = 3600 * 4
    
    static let today: WorkSchedule = WorkSchedule(date: Date())
    
    private(set) var dateId: String
    private(set) var startingWorkTime: Date?
    private(set) var morning: ScheduleType?
    private(set) var afternoon: ScheduleType?
    private(set) var overtime: ScheduleType?
    var isEditingMode: Bool = false
    
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
        self.startingWorkTime = self.makeStartingWorkTimeDate()
        self.morning = .morning(.holiday) // FIXME: Temp
        self.afternoon = .afternoon(.work) // FIXME: Temp
        //self.overtime = .overtime(Date()) // FIXME: Temp
    }
}

// MARK: - Extension for methods added
extension WorkSchedule {
    mutating func updateStartingWorkTime(_ timeDate: Date) {
        print("DB - Starting work time updated")// FIXME: DB
        self.startingWorkTime = timeDate
    }
    
    mutating func makeStartingWorkTimeDate() -> Date? {
        if let startingWorkTimeSetting = SupportingMethods.shared.useAppSetting(for: .startingWorkTimeSetting) as? [String:Any],
            let type = startingWorkTimeSetting["name"] as? String,
            type == "normalType",
            let startingWorkTime = startingWorkTimeSetting["startingWorkTime"] as? Double {
            let hour = (Int(startingWorkTime * 10)) / 10
            let minute = Int((Double((Int(startingWorkTime * 10)) % 10) / 10.0) * 60)
            
            var calendar = Calendar.current
            calendar.timeZone = TimeZone.current
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
            let todayDateComponents = DateComponents(timeZone: TimeZone.current, year: dateComponents.year!, month: dateComponents.month!, day: dateComponents.day!, hour: hour, minute: minute)
            return calendar.date(from: todayDateComponents)
            
        } else {
            return nil
        }
    }
    
    func updateToday() {
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
    
    func makeNewScheduleBasedOnTodayScheduleCount(_ withAssociatedValue: Any) -> ScheduleType? {
        if self.count == 0 {
            if let workType = withAssociatedValue as? WorkType {
                return .morning(workType)
            }
            
            return nil
            
        } else if self.count == 1 {
            if let workType = withAssociatedValue as? WorkType {
                return .afternoon(workType)
            }
            
            return nil
            
        } else if self.count == 2 {
            if let overtime = withAssociatedValue as? Date {
                return .overtime(overtime)
            }
            
            return nil
            
        } else { // 3
            return nil
        }
    }
    
    func whenIsRegularWorkFinish() -> Int? {
        guard let startingWorkTime = self.startingWorkTime else {
            return nil
        }
        
        let startingWorkTimeSeconds = Int(startingWorkTime.timeIntervalSinceReferenceDate)
        
        if case .morning(let workType) = self.morning, case .work = workType,
           case .afternoon(let workType) = self.afternoon, case .work = workType {
            return startingWorkTimeSeconds + type(of: self).secondsOfFourHours + type(of: self).secondsOfOneHour + type(of: self).secondsOfFourHours
            
        } else if case .morning(let workType) = self.morning, case .work = workType {
            return startingWorkTimeSeconds + type(of: self).secondsOfFourHours
            
        } else if case .afternoon(let workType) = self.afternoon, case .work = workType {
            return startingWorkTimeSeconds + type(of: self).secondsOfFourHours
            
        } else {
            return nil
        }
    }
}
