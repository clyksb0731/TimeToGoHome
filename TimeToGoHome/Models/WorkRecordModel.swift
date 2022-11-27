//
//  WorkRecordModel.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/11/28.
//

import Foundation

struct WorkRecord {
    var yearMonth: String
    var schedules: [DailySchedule]
}

struct DailySchedule {
    var dateId: Int
    var day: Int
    var morning: WorkTimeType
    var afternoon: WorkTimeType
    var overtime: Int?
}
