//
//  WorkScheduleModel.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/03/04.
//

import Foundation

enum ScheduleType {
    case scheduling
    case holiday
    case work
    case vacation
    case overtime(overWorkMinute: Int)
}


struct WorkSchedule {
    static var today: WorkSchedule = WorkSchedule(date: Date())
    
    private var dateId: String
    private var morning: ScheduleType?
    private var afternoon: ScheduleType?
    private var overtime: ScheduleType?
    
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
        if case .scheduling = morning, case .holiday = morning, case .work = morning, case .vacation = morning,
           case .scheduling = afternoon, case .holiday = afternoon, case .work = afternoon, case .vacation = afternoon,
           case .overtime(let overtimeValue) = overtime {
            // Update morning & afternoon & overtime
        }
    }
    
    mutating func updateRegularScheduleForDateId(_ dateId: String, morning: ScheduleType, afternoon: ScheduleType) {
        // Find schedule from DB and update it.
        if case .scheduling = morning, case .holiday = morning, case .work = morning, case .vacation = morning,
           case .scheduling = afternoon, case .holiday = afternoon, case .work = afternoon, case .vacation = afternoon {
            // Update morning & afternoon
        }
    }
    
    mutating func updateOvertimeScheduleForDateId(_ dateId: String, overtime: ScheduleType) {
        // Find schedule from DB and update it.
        if case .overtime(let overtimeValue) = overtime {
            // Update overtime
        }
    }
    
    private mutating func scheduling(dateId: String) {
        // Check DB if there is already today schedule.
        // &&
        // Check tody schedule condition for initial setting.
        self.morning = .work // FIXME: Temp
        self.afternoon = .work // FIXME: Temp
        self.overtime = nil // FIXME: Temp
    }
}
