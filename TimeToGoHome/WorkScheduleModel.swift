//
//  WorkScheduleModel.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/03/04.
//

import Foundation

enum WorkType: String {
    case holiday = "holiday"
    case work = "work"
    case vacation = "vacation"
}

enum ScheduleType {
    case morning(WorkType)
    case afternoon(WorkType)
    case overtime(Int)
}

struct WorkSchedule {
    static var today: WorkSchedule = WorkSchedule(date: Date())
    
    private(set) var dateId: String
    private(set) var morning: ScheduleType?
    private(set) var afternoon: ScheduleType?
    private(set) var overtime: ScheduleType?
    
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
    
    init(date: Date) {
        // Make today date id
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyyMMdd"
        self.dateId = dateFormatter.string(from: date)
        
        self.scheduling(dateId: self.dateId)
    }
    
    init(dateId: String) {
        self.dateId = dateId
        
        self.scheduling(dateId: dateId)
    }
    
    mutating func updateScheduleForDateId(_ dateId: String, morning: ScheduleType, afternoon: ScheduleType, overtime: ScheduleType) {
        // Find schedule from DB and update it.
        if case .morning(let morningWorkType) = morning,
            case .afternoon(let afternoonWorkType) = afternoon,
            case .overtime(let overtimeMinute) = overtime {
            // Update morning & afternoon & overtime
        }
    }
    
    mutating func updateRegularScheduleForDateId(_ dateId: String, morning: ScheduleType, afternoon: ScheduleType) {
        // Find schedule from DB and update it.
        if case .morning(let morningWorkType) = morning,
            case .afternoon(let afternoonWorkType) = afternoon {
            // Update morning & afternoon
        }
    }
    
    mutating func updateOvertimeScheduleForDateId(_ dateId: String, overtime: ScheduleType) {
        // Find schedule from DB and update it.
        if case .overtime(let overtimeMinute) = overtime {
            // Update overtime
        }
    }
    
    private mutating func scheduling(dateId: String) {
        // Check DB if there is already today schedule.
        // &&
        // Check tody schedule condition for initial setting.
        self.morning = .morning(.holiday) // FIXME: Temp
        self.afternoon = .afternoon(.work) // FIXME: Temp
        self.overtime = .overtime(59) // FIXME: Temp
    }
}
